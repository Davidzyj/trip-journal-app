import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Trip.startDate, order: .reverse) private var trips: [Trip]
    @State private var isShowingNewTrip = false
    @State private var isShowingSettings = false
    @State private var navigationPath: [Trip] = []
    @State private var didPrepareScreenshotState = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
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
            .onAppear {
                prepareScreenshotState()
            }
        }
    }

    private func deleteTrips(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(trips[index])
        }
    }

    private func prepareScreenshotState() {
        guard ScreenshotFixtures.isEnabled, !didPrepareScreenshotState else {
            return
        }

        didPrepareScreenshotState = true

        guard let trip = ScreenshotFixtures.seedIfNeeded(in: modelContext) else {
            return
        }

        switch ScreenshotFixtures.initialScreen {
        case .detail:
            navigationPath = [trip]
        case .settings:
            isShowingSettings = true
        case .home:
            break
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

enum ScreenshotFixtures {
    enum InitialScreen: String {
        case home
        case detail
        case settings
    }

    static var isEnabled: Bool {
        ProcessInfo.processInfo.environment["UITEST_SCREENSHOTS"] == "1"
    }

    static var initialScreen: InitialScreen {
        let value = ProcessInfo.processInfo.environment["UITEST_INITIAL_SCREEN"] ?? InitialScreen.home.rawValue
        return InitialScreen(rawValue: value) ?? .home
    }

    static func seedIfNeeded(in modelContext: ModelContext) -> Trip? {
        var descriptor = FetchDescriptor<Trip>()
        descriptor.fetchLimit = 1

        if let existingTrip = try? modelContext.fetch(descriptor).first {
            return existingTrip
        }

        let trip = sampleTrip()
        modelContext.insert(trip)

        trip.packingItems = samplePackingItems(for: trip)
        trip.transports = sampleTransports(for: trip)
        trip.places = samplePlaces(for: trip)
        trip.entries = sampleEntries(for: trip)

        try? modelContext.save()
        return trip
    }

    private static func sampleTrip() -> Trip {
        Trip(
            title: localized(english: "Kyoto Spring Walk", chinese: "京都春日漫游"),
            destination: localized(english: "Kyoto, Japan", chinese: "日本京都"),
            startDate: date(year: 2026, month: 4, day: 8),
            endDate: date(year: 2026, month: 4, day: 13),
            summary: localized(
                english: "A quiet six-day trip for temples, trains, river paths, and small notes written between stops.",
                chinese: "一次六天的安静旅行，寺院、列车、河边小路，还有写在路途间的片刻心情。"
            )
        )
    }

    private static func samplePackingItems(for trip: Trip) -> [PackingItem] {
        [
            PackingItem(name: localized(english: "Passport", chinese: "护照"), note: localized(english: "Keep in front pocket", chinese: "放在随身小包"), isPacked: true, trip: trip),
            PackingItem(name: localized(english: "Light jacket", chinese: "轻薄外套"), note: localized(english: "Cool evenings by the river", chinese: "河边夜晚会有些凉"), isPacked: true, trip: trip),
            PackingItem(name: localized(english: "Travel journal", chinese: "旅行手账本"), note: localized(english: "For stamps and tiny sketches", chinese: "盖章和简单速写"), isPacked: true, trip: trip),
            PackingItem(name: localized(english: "Camera charger", chinese: "相机充电器"), note: localized(english: "Check before leaving", chinese: "出门前再确认"), isPacked: false, trip: trip)
        ]
    }

    private static func sampleTransports(for trip: Trip) -> [TransportRecord] {
        [
            TransportRecord(
                type: "transport.type.flight",
                title: localized(english: "Flight MU 729", chinese: "MU 729 航班"),
                departure: localized(english: "Shanghai", chinese: "上海"),
                arrival: localized(english: "Osaka", chinese: "大阪"),
                date: date(year: 2026, month: 4, day: 8, hour: 9, minute: 35),
                note: localized(english: "Window seat, clear morning light.", chinese: "靠窗座位，早晨的光线很好。"),
                trip: trip
            ),
            TransportRecord(
                type: "transport.type.train",
                title: localized(english: "Haruka Express", chinese: "Haruka 特急"),
                departure: localized(english: "Kansai Airport", chinese: "关西机场"),
                arrival: localized(english: "Kyoto Station", chinese: "京都站"),
                date: date(year: 2026, month: 4, day: 8, hour: 13, minute: 10),
                note: localized(english: "First stamp collected at the station.", chinese: "在车站盖下第一枚纪念章。"),
                trip: trip
            )
        ]
    }

    private static func samplePlaces(for trip: Trip) -> [PlaceVisit] {
        [
            PlaceVisit(
                name: localized(english: "Philosopher's Path", chinese: "哲学之道"),
                city: localized(english: "Kyoto", chinese: "京都"),
                date: date(year: 2026, month: 4, day: 9),
                impression: localized(english: "Cherry petals moved slowly on the canal.", chinese: "樱花瓣在水面上慢慢漂过。"),
                trip: trip
            ),
            PlaceVisit(
                name: localized(english: "Fushimi Inari", chinese: "伏见稻荷大社"),
                city: localized(english: "Kyoto", chinese: "京都"),
                date: date(year: 2026, month: 4, day: 10),
                impression: localized(english: "Red gates, mountain air, and a long quiet climb.", chinese: "红色鸟居、山间空气，还有一段很安静的上坡路。"),
                trip: trip
            )
        ]
    }

    private static func sampleEntries(for trip: Trip) -> [JournalEntry] {
        [
            JournalEntry(
                title: localized(english: "First evening in Gion", chinese: "抵达祇园的第一晚"),
                body: localized(
                    english: "Lanterns turned on one by one. I wrote down the route while the street was still warm from the day.",
                    chinese: "灯笼一盏盏亮起来。我趁街道还留着白天的温度，把今天走过的路线记了下来。"
                ),
                mood: localized(english: "Calm", chinese: "平静"),
                date: date(year: 2026, month: 4, day: 8, hour: 20, minute: 20),
                trip: trip
            ),
            JournalEntry(
                title: localized(english: "Train window", chinese: "列车窗边"),
                body: localized(
                    english: "The city moved past in small pieces: rooftops, vending machines, school bags, and a sudden line of mountains.",
                    chinese: "城市从窗边一小段一小段地退后：屋顶、自动贩卖机、书包，还有突然出现的山线。"
                ),
                mood: localized(english: "Moved", chinese: "触动"),
                date: date(year: 2026, month: 4, day: 9, hour: 10, minute: 40),
                trip: trip
            )
        ]
    }

    private static func localized(english: String, chinese: String) -> String {
        AppLocale.appLanguageIdentifier == "zh-Hans" ? chinese : english
    }

    private static func date(year: Int, month: Int, day: Int, hour: Int = 12, minute: Int = 0) -> Date {
        Calendar(identifier: .gregorian).date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)) ?? Date()
    }
}
