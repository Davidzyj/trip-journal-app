import Foundation
import SwiftData

@Model
final class Trip {
    var id: UUID
    var title: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var summary: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \PackingItem.trip)
    var packingItems: [PackingItem]

    @Relationship(deleteRule: .cascade, inverse: \TransportRecord.trip)
    var transports: [TransportRecord]

    @Relationship(deleteRule: .cascade, inverse: \PlaceVisit.trip)
    var places: [PlaceVisit]

    @Relationship(deleteRule: .cascade, inverse: \JournalEntry.trip)
    var entries: [JournalEntry]

    init(title: String, destination: String, startDate: Date, endDate: Date, summary: String = "") {
        self.id = UUID()
        self.title = title
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.summary = summary
        self.createdAt = Date()
        self.packingItems = []
        self.transports = []
        self.places = []
        self.entries = []
    }
}

@Model
final class PackingItem {
    var id: UUID
    var name: String
    var note: String
    var isPacked: Bool
    var createdAt: Date
    var trip: Trip?

    init(name: String, note: String = "", isPacked: Bool = false, trip: Trip? = nil) {
        self.id = UUID()
        self.name = name
        self.note = note
        self.isPacked = isPacked
        self.createdAt = Date()
        self.trip = trip
    }
}

@Model
final class TransportRecord {
    var id: UUID
    var type: String
    var title: String
    var departure: String
    var arrival: String
    var date: Date
    var note: String
    var trip: Trip?

    init(type: String, title: String, departure: String, arrival: String, date: Date, note: String = "", trip: Trip? = nil) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.departure = departure
        self.arrival = arrival
        self.date = date
        self.note = note
        self.trip = trip
    }
}

@Model
final class PlaceVisit {
    var id: UUID
    var name: String
    var city: String
    var date: Date
    var impression: String
    var trip: Trip?

    init(name: String, city: String, date: Date, impression: String = "", trip: Trip? = nil) {
        self.id = UUID()
        self.name = name
        self.city = city
        self.date = date
        self.impression = impression
        self.trip = trip
    }
}

@Model
final class JournalEntry {
    var id: UUID
    var title: String
    var body: String
    var mood: String
    var date: Date
    var trip: Trip?

    init(title: String, body: String, mood: String, date: Date = Date(), trip: Trip? = nil) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.mood = mood
        self.date = date
        self.trip = trip
    }
}

extension Trip {
    var sortedPackingItems: [PackingItem] {
        packingItems.sorted { $0.createdAt < $1.createdAt }
    }

    var sortedTransports: [TransportRecord] {
        transports.sorted { $0.date < $1.date }
    }

    var sortedPlaces: [PlaceVisit] {
        places.sorted { $0.date < $1.date }
    }

    var sortedEntries: [JournalEntry] {
        entries.sorted { $0.date < $1.date }
    }

    var packedCount: Int {
        packingItems.filter(\.isPacked).count
    }

    var dayCount: Int {
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)
        return max(1, (Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0) + 1)
    }
}

