//
//  Race.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import Foundation

// MARK: - Race
struct Race: Codable {
    let status: Int?
    let data: DataClass?
    let message: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let nextToGoIDS: [String]?
    let raceSummaries: [String: RaceSummary]?
    enum CodingKeys: String, CodingKey {
        case nextToGoIDS = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}

// MARK: - RaceSummary
struct RaceSummary: Codable, Hashable {
    let raceID: String?
    let raceName: String?
    let raceNumber: Int?
    let meetingID: String?
    let meetingName: String?
    let categoryID: String?
    let advertisedStart: AdvertisedStart?
    let raceForm: RaceForm?
    let venueID: String?
    let venueName: String?
    let venueState: String?
    let venueCountry: VenueCountry?
    enum CodingKeys: String, CodingKey {
        case raceID = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingID = "meeting_id"
        case meetingName = "meeting_name"
        case categoryID = "category_id"
        case advertisedStart = "advertised_start"
        case raceForm = "race_form"
        case venueID = "venue_id"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(raceID)
        hasher.combine(raceName)
        hasher.combine(raceNumber)
        hasher.combine(meetingID)
    }
    static func == (lhs: RaceSummary, rhs: RaceSummary) -> Bool {
        return lhs.raceID == rhs.raceID &&
        lhs.raceName == rhs.raceName &&
        lhs.raceNumber == rhs.raceNumber &&
        lhs.meetingID == rhs.meetingID
    }
}

// MARK: - AdvertisedStart
struct AdvertisedStart: Codable, Hashable {
    let seconds: Int?
}

// MARK: - RaceForm
struct RaceForm: Codable, Hashable {
    let distance: Int?
    let distanceType: DistanceType?
    let distanceTypeID: String?
    let trackCondition: DistanceType?
    let trackConditionID: String?
    let weather: DistanceType?
    let weatherID: String?
    let raceComment: String?
    let additionalData: String?
    let generated: Int?
    let silkBaseURL: SilkBaseURL?
    let raceCommentAlternative: String?
    enum CodingKeys: String, CodingKey {
        case distance
        case distanceType = "distance_type"
        case distanceTypeID = "distance_type_id"
        case trackCondition = "track_condition"
        case trackConditionID = "track_condition_id"
        case weather
        case weatherID = "weather_id"
        case raceComment = "race_comment"
        case additionalData = "additional_data"
        case generated
        case silkBaseURL = "silk_base_url"
        case raceCommentAlternative = "race_comment_alternative"
    }
}

// MARK: - DistanceType
struct DistanceType: Codable, Hashable {
    let id: String?
    let name: String?
    let shortName: String?
    let iconURI: String?
    enum CodingKeys: String, CodingKey {
        case id, name
        case shortName = "short_name"
        case iconURI = "icon_uri"
    }
}

enum SilkBaseURL: String, Codable {
    case drr38Safykj6SCloudfrontNet = "drr38safykj6s.cloudfront.net"
}

enum VenueCountry: String, Codable {
    case aus = "AUS"
    case ind = "IND"
    case jpn = "JPN"
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        // If the raw value matches any of the known cases, use it
        if let knownCountry = VenueCountry(rawValue: rawValue) {
            self = knownCountry
        } else {
            // Handle unknown country codes, e.g., by setting a default or logging
            self = .aus // Default value
        }
    }
}
