//
//  InsultMeWidget.swift
//  InsultMeWidget
//
//  Created by Nikko Laurenciana on 02.02.24.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "group.dev.nikkothe.insultme"

struct Provider: TimelineProvider {
    func placeholder(
        in context: Context
    ) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            insult: "Nice try, superstar. Maybe next time you'll impress yourself."
        )
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (
            SimpleEntry
        ) -> ()
    ) {
        let data = UserDefaults.init(
            suiteName: widgetGroupId
        )
        let entry = SimpleEntry(
            date: Date(),
            insult: data?.string(
                forKey: "insult"
            ) ?? "No Title Set"
        )
        completion(
            entry
        )
    }
    
    func getTimeline(
        in context: Context,
        completion: @escaping (
            Timeline<Entry>
        ) -> Void
    ) {
        getSnapshot(
            in: context
        ) { (
            entry
        ) in
            let timeline = Timeline(
                entries: [entry],
                policy: .atEnd
            )
            completion(
                timeline
            )
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let insult: String
}

struct InsultMeWidgetEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(
        suiteName: widgetGroupId
    )
    
    @Environment(
        \.widgetFamily
    ) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            Text(
                entry.insult
            )
        case .systemLarge:
      
            VStack(
                alignment: .leading
            ) {
                Text(
                    "InsultMe"
                )
                .font(
                    .subheadline
                )
                .foregroundColor(
                    Color.gray
                )
                .unredacted()
                
                Text(
                    entry.insult
                )
                .font(
                    .largeTitle
                )
                }.padding()
        case .systemMedium:
            ZStack {
                HStack {
                    Text(
                        "🤔"
                    )
                    .unredacted()
                    .font(
                        .system(
                            size: 50
                        )
                    )
                    Text(
                        entry.insult
                    )
                }.padding()
            }
        default:
            Text(
                entry.insult
            )
        }
        
        
        
        
    }
}

struct InsultMeWidget: Widget {
    let kind: String = "InsultMeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            if #available(
                iOS 17.0,
                *
            ) {
                InsultMeWidgetEntryView(
                    entry: entry
                )
                .containerBackground(
                    .fill.tertiary,
                    for: .widget
                )
            } else {
                InsultMeWidgetEntryView(
                    entry: entry
                )
                .padding()
                .background()
            }
        }
        .configurationDisplayName(
            "My Widget"
        )
        .description(
            "This is an example widget."
        )
    }
}

#Preview(
    as: .systemSmall
) {
    InsultMeWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        insult: "Nice try, superstar. Maybe next time you'll impress yourself."
    )
}
