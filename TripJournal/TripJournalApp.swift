import SwiftData
import SwiftUI

@main
struct TripJournalApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: Trip.self, PackingItem.self, TransportRecord.self, PlaceVisit.self, JournalEntry.self)
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

