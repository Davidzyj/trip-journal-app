import SwiftData
import SwiftUI

struct TripFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    @State private var summary = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("trip.section.basic") {
                    TextField("trip.title.placeholder", text: $title)
                    TextField("trip.destination.placeholder", text: $destination)
                    DatePicker("trip.start", selection: $startDate, displayedComponents: .date)
                    DatePicker("trip.end", selection: $endDate, in: startDate..., displayedComponents: .date)
                }

                Section("trip.section.note") {
                    TextField("trip.summary.placeholder", text: $summary, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("trip.new")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") {
                        saveTrip()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveTrip() {
        let trip = Trip(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            destination: destination.trimmingCharacters(in: .whitespacesAndNewlines),
            startDate: startDate,
            endDate: endDate,
            summary: summary.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        modelContext.insert(trip)
        dismiss()
    }
}

