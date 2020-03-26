// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

function convertToStatus(json response) returns Status {
    Status status = {
        createdAt: <string>response.created_at,
        id: <int>response.id,
        text: <string>response.text,
        'source: <string>response.'source,
        truncated: <boolean>response.truncated,
        favorited: <boolean>response.favorited,
        retweeted: <boolean>response.retweeted,
        favoriteCount: <int>response.favorite_count,
        retweetCount: <int>response.retweet_count,
        lang: <string>response.lang
    };
    return status;
}

//function convertToInt(json jsonVal) returns int {
//    if (jsonVal is int) {
//        return jsonVal;
//    }
//    panic error("Error occurred when converting " + jsonVal.toString() + " to int");
//}
//
//function convertToBoolean(json jsonVal) returns boolean {
//    if (jsonVal is boolean) {
//        return jsonVal;
//    }
//    panic error("Error occurred when converting " + jsonVal.toString() + " to boolean");
//}
//
//function convertToFloat(json jsonVal) returns float {
//    if (jsonVal is float) {
//        return jsonVal;
//    }
//    panic error("Error occurred when converting " + jsonVal.toString() + " to float");
//}
//
//function convertToGeoLocation(json jsonStatus) returns GeoLocation {
//    GeoLocation geoLocation = {};
//    var latitude = jsonStatus.geo.latitude;
//    if (latitude is json) {
//        geoLocation.latitude = latitude != null ? convertToFloat(latitude) : 0.0;
//    }
//    var longitude = jsonStatus.geo.longitude;
//    if (longitude is json) {
//        geoLocation.longitude = longitude != null ? convertToFloat(longitude) : 0.0;
//    }
//    return geoLocation;
//}
//
//function convertToStatuses(json[] jsonStatuses) returns Status[] {
//    Status[] statuses = [];
//    int i = 0;
//    foreach json jsonStatus in jsonStatuses {
//        statuses[i] = convertToStatus(jsonStatus);
//        i = i + 1;
//    }
//    return statuses;
//}
//
//function convertToLocations(json[] jsonLocations) returns Location[] {
//    Location[] locations = [];
//    int i = 0;
//    foreach json jsonLocation in jsonLocations {
//        locations[i] = convertToLocation(jsonLocation);
//        i = i + 1;
//    }
//    return locations;
//}
//
//function convertToLocation(json jsonLocation) returns Location {
//    Location location = {};
//    var countryName = jsonLocation.country;
//    if (countryName is json) {
//       location.countryName = countryName != null ? countryName.toString() : "";
//    }
//    var countryCode = jsonLocation.countryCode;
//    if (countryCode is json) {
//       location.countryCode = countryCode != null ? countryCode.toString() : "";
//    }
//    var name = jsonLocation.name;
//    if (name is json) {
//       location.name = name != null ? name.toString() : "";
//    }
//    var placeType = jsonLocation.placeType;
//    if (placeType is json) {
//       location.placeType = placeType != null ? convertToPlaceType(placeType) : {};
//    }
//    var url = jsonLocation.url;
//    if (url is json) {
//       location.url = url != null ? url.toString() : "";
//    }
//    var woeid = jsonLocation.woeid;
//    if (woeid is json) {
//       location.woeid = woeid != null ? convertToInt(woeid) : 0;
//    }
//    return location;
//}
//
//function convertToPlaceType(json jsonPlaceType) returns PlaceType {
//    PlaceType placeType = {};
//    var code = jsonPlaceType.code;
//    if (code is json) {
//       placeType.code = code != null ? convertToInt(code) : 0;
//    }
//    var name = jsonPlaceType.name;
//    if (name is json) {
//       placeType.name = name != null ? name.toString() : "";
//    }
//    return placeType;
//}
//
//function convertTrends(json jsonTrends) returns Trends[] {
//    Trends[] trends = [];
//    if (jsonTrends is json[]) {
//        trends[0] = convertToTrends(jsonTrends[0]);
//    }
//    return trends;
//}
//
//function convertToTrends(json jsonTrends) returns Trends {
//    Trends trendList = {};
//    trendList.trends = convertTrendList(<json[]>jsonTrends.trends);
//    trendList.location = convertToLocations(<json[]>jsonTrends.locations);
//    var createdAt = jsonTrends.created_at;
//    if (createdAt is json) {
//       trendList.createdAt = createdAt != null ? createdAt.toString() : "";
//    }
//    return trendList;
//}
//
//function convertTrendList(json[] jsonTrends) returns Trend[] {
//    Trend[] trendList = [];
//    int i = 0;
//    foreach json jsonTrend in jsonTrends {
//        trendList[i] = convertToTrend(jsonTrend);
//        i = i + 1;
//    }
//    return trendList;
//}
//
//function convertToTrend(json jsonTrend) returns Trend {
//    Trend trend = {};
//    var name = jsonTrend.name;
//    if (name is json) {
//       trend.name = name != null ? name.toString() : "";
//    }
//    var url = jsonTrend.url;
//    if (url is json) {
//       trend.url = url != null ? url.toString() : "";
//    }
//    var promotedContent = jsonTrend.promoted_content;
//    if (promotedContent is json) {
//       trend.promotedContent = promotedContent != null ? promotedContent.toString() : "";
//    }
//    var trendQuery = jsonTrend.query;
//    if (trendQuery is json) {
//       trend.trendQuery = trendQuery != null ? trendQuery.toString() : "";
//    }
//    var tweetVolume = jsonTrend.tweet_volume;
//    if (tweetVolume is json) {
//       trend.tweetVolume = tweetVolume != null ? convertToInt(tweetVolume) : 0;
//    }
//    return trend;
//}
