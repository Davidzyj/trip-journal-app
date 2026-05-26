import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Trip.startDate, order: .reverse) private var trips: [Trip]
    @State private var isShowingNewTrip = false
    @State private var isShowingSettings = false

    var body: some View {
        NavigationStack {
            Group {
                if trips.isEmpty {
                    EmptyTripView {
                        isShowingNewTrip = true
                    }
                } else {
                    List {
                        ForEach(trips) { trip in
                            NavigationLink(value: trip) {
                                TripRowView(trip: trip)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteTrips)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("app.title")
            .navigationDestination(for: Trip.self) { trip in
                TripDetailView(trip: trip)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        Label("settings.title", systemImage: "gearshape")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingNewTrip = true
                    } label: {
                        Label("trip.new", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingNewTrip) {
                TripFormView()
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
        }
    }

    private func deleteTrips(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(trips[index])
        }
    }
}

private struct EmptyTripView: View {
    let addAction: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.teal.opacity(0.92), Color.indigo.opacity(0.88), Color.orange.opacity(0.78)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 150, height: 150)

                Image(systemName: "map.fill")
                    .font(.system(size: 62, weight: .semibold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.22), radius: 10, y: 6)
            }

            VStack(spacing: 10) {
                Text("empty.title")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text("empty.subtitle")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
            }

            Button(action: addAction) {
                Label("trip.new", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 32)

            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}

private struct TripRowView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(trip.title)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Label(trip.destination, systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 12)

                Text("\(trip.dayCount)")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.teal, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .accessibilityLabel(Text("trip.days.count \(trip.dayCount)"))
            }

            Text(tripDateRange)
                .font(.footnote)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                StatPill(title: "stat.packing", value: "\(trip.packedCount)/\(trip.packingItems.count)", icon: "checklist")
                StatPill(title: "stat.places", value: "\(trip.places.count)", icon: "map")
                StatPill(title: "stat.entries", value: "\(trip.entries.count)", icon: "book.pages")
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
        .padding(.vertical, 6)
    }

    private var tripDateRange: String {
        let start = trip.startDate.formatted(date: .abbreviated, time: .omitted)
        let end = trip.endDate.formatted(date: .abbreviated, time: .omitted)
        return "\(start) - \(end)"
    }
}

private struct StatPill: View {
    let title: LocalizedStringKey
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
            Text(value)
                .font(.caption.bold())
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color(.tertiarySystemGroupedBackground), in: Capsule())
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Trip.self, PackingItem.self, TransportRecord.self, PlaceVisit.self, JournalEntry.self], inMemory: true)
}
