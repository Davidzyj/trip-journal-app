import SwiftUI

struct AddPackingItemView: View {
    @Environment(\.dismiss) private var dismiss
    let trip: Trip

    @State private var name = ""
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("packing.name.placeholder", text: $name)
                TextField("common.note.placeholder", text: $note, axis: .vertical)
                    .lineLimit(2...5)
            }
            .navigationTitle("packing.add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") {
                        trip.packingItems.append(PackingItem(name: trimmed(name), note: trimmed(note), trip: trip))
                        dismiss()
                    }
                    .disabled(trimmed(name).isEmpty)
                }
            }
        }
    }
}

struct AddTransportView: View {
    @Environment(\.dismiss) private var dismiss
    let trip: Trip

    @State private var type = "transport.type.flight"
    @State private var title = ""
    @State private var departure = ""
    @State private var arrival = ""
    @State private var date = Date()
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Picker("transport.type", selection: $type) {
                    Text("transport.type.flight").tag("transport.type.flight")
                    Text("transport.type.train").tag("transport.type.train")
                    Text("transport.type.car").tag("transport.type.car")
                    Text("transport.type.ship").tag("transport.type.ship")
                }

                TextField("transport.title.placeholder", text: $title)
                TextField("transport.departure.placeholder", text: $departure)
                TextField("transport.arrival.placeholder", text: $arrival)
                DatePicker("common.date", selection: $date)
                TextField("common.note.placeholder", text: $note, axis: .vertical)
                    .lineLimit(2...5)
            }
            .navigationTitle("transport.add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") {
                        trip.transports.append(
                            TransportRecord(
                                type: type,
                                title: trimmed(title),
                                departure: trimmed(departure),
                                arrival: trimmed(arrival),
                                date: date,
                                note: trimmed(note),
                                trip: trip
                            )
                        )
                        dismiss()
                    }
                    .disabled(trimmed(title).isEmpty || trimmed(departure).isEmpty || trimmed(arrival).isEmpty)
                }
            }
        }
    }
}

struct AddPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    let trip: Trip

    @State private var name = ""
    @State private var city = ""
    @State private var date = Date()
    @State private var impression = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("place.name.placeholder", text: $name)
                TextField("place.city.placeholder", text: $city)
                DatePicker("common.date", selection: $date, displayedComponents: .date)
                TextField("place.impression.placeholder", text: $impression, axis: .vertical)
                    .lineLimit(2...6)
            }
            .navigationTitle("place.add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") {
                        trip.places.append(
                            PlaceVisit(name: trimmed(name), city: trimmed(city), date: date, impression: trimmed(impression), trip: trip)
                        )
                        dismiss()
                    }
                    .disabled(trimmed(name).isEmpty || trimmed(city).isEmpty)
                }
            }
        }
    }
}

struct AddJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    let trip: Trip

    @State private var title = ""
    @State private var bodyText = ""
    @State private var mood = "mood.calm"
    @State private var date = Date()

    var body: some View {
        NavigationStack {
            Form {
                TextField("journal.title.placeholder", text: $title)
                Picker("journal.mood", selection: $mood) {
                    Text("mood.calm").tag("mood.calm")
                    Text("mood.excited").tag("mood.excited")
                    Text("mood.tired").tag("mood.tired")
                    Text("mood.moved").tag("mood.moved")
                }
                DatePicker("common.date", selection: $date)
                TextField("journal.body.placeholder", text: $bodyText, axis: .vertical)
                    .lineLimit(5...12)
            }
            .navigationTitle("journal.add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") {
                        trip.entries.append(
                            JournalEntry(title: trimmed(title), body: trimmed(bodyText), mood: String(localized: String.LocalizationValue(mood)), date: date, trip: trip)
                        )
                        dismiss()
                    }
                    .disabled(trimmed(title).isEmpty || trimmed(bodyText).isEmpty)
                }
            }
        }
    }
}

private func trimmed(_ value: String) -> String {
    value.trimmingCharacters(in: .whitespacesAndNewlines)
}

