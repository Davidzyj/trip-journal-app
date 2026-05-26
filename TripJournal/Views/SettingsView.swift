import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        Image("AppIconPreview")
                            .resizable()
                            .frame(width: 58, height: 58)
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("app.title")
                                .font(.headline)
                            Text("settings.version")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("settings.links") {
                    Link(destination: AppLocale.privacyURL) {
                        Label("settings.privacy", systemImage: "hand.raised")
                    }

                    Link(destination: AppLocale.supportURL) {
                        Label("settings.support", systemImage: "envelope")
                    }
                }

                Section("settings.privacy.section") {
                    Text("settings.privacy.local")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("settings.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

