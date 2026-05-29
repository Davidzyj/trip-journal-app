#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEVICE_NAME="${DEVICE_NAME:-DecisionLog Screenshots 6.5}"
DESTINATION="platform=iOS Simulator,name=${DEVICE_NAME},OS=18.6"
DERIVED_DATA="${ROOT}/build/DerivedData"
SCREENSHOT_ROOT="${ROOT}/screenshots/6.5"
APP_PATH="${DERIVED_DATA}/Build/Products/Debug-iphonesimulator/TripJournal.app"
BUNDLE_ID="com.zhouyajie.tripjournal"
MIN_NONWHITE_RATIO="${MIN_NONWHITE_RATIO:-0.08}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-8}"
POLL_SECONDS="${POLL_SECONDS:-4}"

rm -rf "${SCREENSHOT_ROOT}"
mkdir -p "${ROOT}/build" "${SCREENSHOT_ROOT}/en" "${SCREENSHOT_ROOT}/zh-Hans"

xcodebuild \
  -project "${ROOT}/TripJournal.xcodeproj" \
  -scheme TripJournal \
  -destination "${DESTINATION}" \
  -derivedDataPath "${DERIVED_DATA}" \
  build \
  > "${ROOT}/build/screenshot-build.log"

xcrun simctl boot "${DEVICE_NAME}" >/dev/null 2>&1 || true
xcrun simctl install "${DEVICE_NAME}" "${APP_PATH}"

capture() {
  local language="$1"
  local folder="$2"
  local screen="$3"
  local filename="$4"
  local expected_text="$5"
  local temp_path="${SCREENSHOT_ROOT}/${folder}/.${filename}.tmp.png"
  local ratio
  local text_match

  xcrun simctl terminate "${DEVICE_NAME}" "${BUNDLE_ID}" >/dev/null 2>&1 || true
  SIMCTL_CHILD_UITEST_SCREENSHOTS=1 \
  SIMCTL_CHILD_UITEST_LANGUAGE="${language}" \
  SIMCTL_CHILD_UITEST_INITIAL_SCREEN="${screen}" \
  xcrun simctl launch \
    --terminate-running-process \
    "${DEVICE_NAME}" \
    "${BUNDLE_ID}" >/dev/null

  for _ in $(seq 1 "${MAX_ATTEMPTS}"); do
    sleep "${POLL_SECONDS}"
    xcrun simctl io "${DEVICE_NAME}" screenshot "${temp_path}" >/dev/null
    ratio="$(swift - "${temp_path}" <<'SWIFT'
import Foundation
import ImageIO
import CoreGraphics

let path = CommandLine.arguments[1]
let url = URL(fileURLWithPath: path)
guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
      let image = CGImageSourceCreateImageAtIndex(source, 0, nil),
      let provider = image.dataProvider,
      let data = provider.data,
      let bytes = CFDataGetBytePtr(data) else {
    print("0")
    exit(0)
}

let width = image.width
let height = image.height
let bytesPerRow = image.bytesPerRow
let bytesPerPixel = image.bitsPerPixel / 8
var nonWhite = 0
let total = width * height

for y in 0..<height {
    let row = bytes + y * bytesPerRow
    for x in 0..<width {
        let pixel = row + x * bytesPerPixel
        let red = pixel[0]
        let green = pixel[1]
        let blue = pixel[2]
        let alpha = bytesPerPixel > 3 ? pixel[3] : 255
        if alpha > 0 && (red < 250 || green < 250 || blue < 250) {
            nonWhite += 1
        }
    }
}

let ratio = Double(nonWhite) / Double(total)
print(String(format: "%.5f", ratio))
SWIFT
)"
    text_match="$(swift - "${temp_path}" "${expected_text}" <<'SWIFT'
import AppKit
import Foundation
import Vision

let path = CommandLine.arguments[1]
let expected = CommandLine.arguments[2].lowercased()
let url = URL(fileURLWithPath: path)

guard let image = NSImage(contentsOf: url),
      let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
    print("no")
    exit(0)
}

let request = VNRecognizeTextRequest()
request.recognitionLevel = .accurate
request.usesLanguageCorrection = false
request.recognitionLanguages = ["zh-Hans", "en-US"]

let handler = VNImageRequestHandler(cgImage: cgImage)
try? handler.perform([request])

let text = (request.results ?? [])
    .compactMap { $0.topCandidates(1).first?.string }
    .joined(separator: "\n")
    .lowercased()

print(text.contains(expected) ? "yes" : "no")
SWIFT
)"
    if awk "BEGIN {exit !(${ratio} >= ${MIN_NONWHITE_RATIO})}" && [[ "${text_match}" == "yes" ]]; then
      mv "${temp_path}" "${SCREENSHOT_ROOT}/${folder}/${filename}"
      return 0
    fi
  done

  mv "${temp_path}" "${SCREENSHOT_ROOT}/${folder}/${filename}"
  echo "Warning: screenshot ${folder}/${filename} may still be invalid; expected text '${expected_text}' was not confirmed" >&2
}

capture "en" "en" "home" "01-home.png" "Travel Memo"
capture "en" "en" "detail" "02-detail.png" "Kyoto Spring Walk"
capture "zh-Hans" "zh-Hans" "home" "01-home.png" "旅途记"
capture "zh-Hans" "zh-Hans" "detail" "02-detail.png" "京都春日漫游"

sips -g pixelWidth -g pixelHeight "${SCREENSHOT_ROOT}"/*/*.png \
  > "${SCREENSHOT_ROOT}/dimensions.txt"

printf "Screenshots saved to %s\n" "${SCREENSHOT_ROOT}"
cat "${SCREENSHOT_ROOT}/dimensions.txt"
