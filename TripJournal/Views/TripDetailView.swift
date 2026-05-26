import SwiftData
import SwiftUI

struct TripDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var trip: Trip

    @State private var activeSheet: DetailSheet?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                packingSection
                transportSection
                placeSection
                journalSection
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(trip.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        activeSheet = .packing
                    } label: {
                        Label("packing.add", systemImage: "checklist")
                    }

                    Button {
                        activeSheet = .transport
                    } label: {
                        Label("transport.add", systemImage: "airplane.departure")
                    }

                    Button {
                        activeSheet = .place
                    } label: {
                        Label("place.add", systemImage: "mappin.and.ellipse")
                    }

                    Button {
                        activeSheet = .journal
                    } label: {
                        Label("journal.add", systemImage: "book.pages")
                    }
                } label: {
                    Label("record.add", systemImage: "plus.circle")
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .packing:
                AddPackingItemView(trip: trip)
            case .transport:
                AddTransportView(trip: trip)
            case .place:
                AddPlaceView(trip: trip)
            case .journal:
                AddJournalEntryView(trip: trip)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Label(trip.destination, systemImage: "location.fill")
                        .font(.headline)
                    Text(dateRange)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("\(trip.dayCount)")
                        .font(.title.bold())
                    Text("trip.days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 74, height: 74)
                .background(Color.teal.opacity(0.14), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }

            if !trip.summary.isEmpty {
                Text(trip.summary)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {
                OverviewChip(icon: "checklist", value: "\(trip.packedCount)/\(trip.packingItems.count)", title: "stat.packing")
                OverviewChip(icon: "tram.fill", value: "\(trip.transports.count)", title: "stat.transport")
                OverviewChip(icon: "map.fill", value: "\(trip.places.count)", title: "stat.places")
                OverviewChip(icon: "book.closed.fill", value: "\(trip.entries.count)", title: "stat.entries")
            }
        }
        .padding(18)
        .background(
            LinearGradient(colors: [Color(.secondarySystemGroupedBackground), Color.teal.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
    }

    private var packingSection: some View {
        DetailSection(title: "packing.title", icon: "checklist") {
            if trip.packingItems.isEmpty {
                EmptySectionText("packing.empty")
            } else {
                VStack(spacing: 8) {
                    ForEach(trip.sortedPackingItems) { item in
                        HStack(spacing: 12) {
                            Button {
                                item.isPacked.toggle()
                            } label: {
                                Image(systemName: item.isPacked ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundStyle(item.isPacked ? Color.teal : Color.secondary)
                            }
                            .buttonStyle(.plain)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.name)
                                    .strikethrough(item.isPacked)
                                if !item.note.isEmpty {
                                    Text(item.note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()
                        }
                        .padding(12)
                        .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
            }
        }
    }

    private var transportSection: some View {
        DetailSection(title: "transport.title", icon: "airplane.departure") {
            if trip.transports.isEmpty {
                EmptySectionText("transport.empty")
            } else {
                VStack(spacing: 10) {
                    ForEach(trip.sortedTransports) { transport in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: icon(forTransportType: transport.type))
                                .font(.title3)
                                .foregroundStyle(.indigo)
                                .frame(width: 30)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(transport.title)
                                    .font(.headline)
                                Text("\(transport.departure) -> \(transport.arrival)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(transport.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                if !transport.note.isEmpty {
                                    Text(transport.note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()
                        }
                        .padding(12)
                        .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
            }
        }
    }

    private var placeSection: some View {
        DetailSection(title: "place.title", icon: "mappin.and.ellipse") {
            if trip.places.isEmpty {
                EmptySectionText("place.empty")
            } else {
                VStack(spacing: 10) {
                    ForEach(trip.sortedPlaces) { place in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.orange)
                                .frame(width: 30)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(place.name)
                                    .font(.headline)
                                Text(place.city)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(place.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                if !place.impression.isEmpty {
                                    Text(place.impression)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()
                        }
                        .padding(12)
                        .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
            }
        }
    }

    private var journalSection: some View {
        DetailSection(title: "journal.title", icon: "book.pages") {
            if trip.entries.isEmpty {
                EmptySectionText("journal.empty")
            } else {
                VStack(spacing: 10) {
                    ForEach(trip.sortedEntries) { entry in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(entry.title)
                                    .font(.headline)
                                Spacer()
                                Text(entry.mood)
                                    .font(.subheadline)
                            }
                            Text(entry.body)
                                .font(.body)
                                .foregroundStyle(.secondary)
                            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
            }
        }
    }

    private var dateRange: String {
        let start = trip.startDate.formatted(date: .abbreviated, time: .omitted)
        let end = trip.endDate.formatted(date: .abbreviated, time: .omitted)
        return "\(start) - \(end)"
    }

    private func icon(forTransportType type: String) -> String {
        switch type {
        case "transport.type.train":
            return "tram.fill"
        case "transport.type.car":
            return "car.fill"
        case "transport.type.ship":
            return "ferry.fill"
        default:
            return "airplane"
        }
    }
}

private enum DetailSheet: String, Identifiable {
    case packing
    case transport
    case place
    case journal

    var id: String { rawValue }
}

private struct DetailSection<Content: View>: View {
    let title: LocalizedStringKey
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.headline)
                Spacer()
            }

            content
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct OverviewChip: View {
    let icon: String
    let value: String
    let title: LocalizedStringKey

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.teal)
            Text(value)
                .font(.footnote.bold())
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct EmptySectionText: View {
    let title: LocalizedStringKey

    init(_ title: LocalizedStringKey) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
