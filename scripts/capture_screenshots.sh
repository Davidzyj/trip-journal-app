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
  local temp_path="${SCREENSHOT_ROOT}/${folder}/.${filename}.tmp.png"
  local ratio

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
    if awk "BEGIN {exit !(${ratio} >= ${MIN_NONWHITE_RATIO})}"; then
      mv "${temp_path}" "${SCREENSHOT_ROOT}/${folder}/${filename}"
      return 0
    fi
  done

  mv "${temp_path}" "${SCREENSHOT_ROOT}/${folder}/${filename}"
  echo "Warning: screenshot ${folder}/${filename} may still be blank-ish" >&2
}

capture "en" "en" "home" "01-home.png"
capture "en" "en" "detail" "02-detail.png"
capture "zh-Hans" "zh-Hans" "home" "01-home.png"
capture "zh-Hans" "zh-Hans" "detail" "02-detail.png"

sips -g pixelWidth -g pixelHeight "${SCREENSHOT_ROOT}"/*/*.png \
  > "${SCREENSHOT_ROOT}/dimensions.txt"

printf "Screenshots saved to %s\n" "${SCREENSHOT_ROOT}"
cat "${SCREENSHOT_ROOT}/dimensions.txt"
