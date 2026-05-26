import SwiftData
import SwiftUI

@main
struct TripJournalApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([Trip.self, PackingItem.self, TransportRecord.self, PlaceVisit.self, JournalEntry.self])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: ScreenshotFixtures.isEnabled)
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create local model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, AppLocale.appLocale)
        }
        .modelContainer(modelContainer)
    }
}
