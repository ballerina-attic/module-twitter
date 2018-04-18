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

function convertToStatus(json jsonStatus) returns (Status) {
    Status status = {};
    status.createdAt = jsonStatus.created_at != null ? jsonStatus.created_at.toString() : "";
    status.id = jsonStatus.id != null ? convertToInt(jsonStatus.id) : 0;
    status.text = status.text != null ? jsonStatus.text.toString() : "";
    status.source = jsonStatus.source != null ? jsonStatus.source.toString() : "";
    status.truncated = jsonStatus.truncated != null ? convertToBoolean(jsonStatus.truncated) : false;
    status.inReplyToStatusId = 
                        jsonStatus.in_reply_to_status_id != null ? convertToInt(jsonStatus.in_reply_to_status_id) : 0;
    status.inReplyToUserId = jsonStatus.in_reply_to_user_id != null ? convertToInt(jsonStatus.in_reply_to_user_id) : 0;
    status.inReplyToScreenName =
                        jsonStatus.in_reply_to_screen_name != null ? jsonStatus.in_reply_to_screen_name.toString() : "";
    status.favorited = jsonStatus.favorited != null ? convertToBoolean(jsonStatus.favorited) : false;
    status.retweeted = jsonStatus.retweeted != null ? convertToBoolean(jsonStatus.retweeted) : false;
    status.favouritesCount = jsonStatus.favourites_count != null ? convertToInt(jsonStatus.favourites_count) : 0;
    status.retweetCount = jsonStatus.retweet_count != null ? convertToInt(jsonStatus.retweet_count) : 0;
    status.lang = jsonStatus.lang != null ? jsonStatus.lang.toString() : "";
    status.geo = jsonStatus.geo != null ? convertToGeoLocation(jsonStatus.geo) : {};

    return status;
}


function convertToInt(json jsonVal) returns (int){
    string stringVal = jsonVal.toString();
    if(stringVal != "") {
       return check <int> stringVal;
    } else {
        return 0;
    }
}

function convertToBoolean(json jsonVal) returns (boolean) {
    string stringVal = jsonVal.toString();
    return <boolean> stringVal;
}

function convertToFloat(json jsonVal) returns (float) {
    string stringVal = jsonVal.toString();
    return check <float> stringVal;
}

function convertToGeoLocation(json jsonStatus) returns (GeoLocation) {
    GeoLocation geoLocation = {};
    geoLocation.latitude = jsonStatus.geo.latitude != null ? convertToFloat(jsonStatus.geo.latitude) : 0;
    geoLocation.longitude = jsonStatus.geo.longitude != null ? convertToFloat(jsonStatus.geo.longitude) : 0;

    return geoLocation;
}

function convertToStatuses(json jsonStatuses) returns Status[] {
    Status[] statuses = [];
    int i = 0;
    foreach jsonStatus in jsonStatuses {
        statuses[i] = convertToStatus(jsonStatus);
        i = i +1;
    }
    return statuses;
}

function convertToLocations(json jsonLocations) returns Location[] {
    Location[] locations = [];
    int i = 0;
    foreach jsonLocation in jsonLocations {
        locations[i] = convertToLocation(jsonLocation);
        i = i +1;
    }
    return locations;
}

function convertToLocation(json jsonLocation) returns (Location) {
    Location location = {};
    location.countryName = jsonLocation.country != null ? jsonLocation.country.toString() : "";
    location.countryCode = jsonLocation.countryCode != null ? jsonLocation.countryCode.toString() : "";
    location.name = jsonLocation.name != null ? jsonLocation.name.toString() : "";
    location.placeType = jsonLocation.placeType != null ? convertToPlaceType(jsonLocation.placeType) : {};
    location.url = jsonLocation.url != null ? jsonLocation.url.toString() : "";
    location.woeid = jsonLocation.woeid != null ? convertToInt(jsonLocation.woeid) : 0;

    return location;
}

function convertToPlaceType(json jsonPlaceType) returns (PlaceType) {
    PlaceType placeType = {};
    placeType.code = jsonPlaceType.code != null ? convertToInt(jsonPlaceType.code) : 0;
    placeType.name = jsonPlaceType.name != null ? jsonPlaceType.name.toString() : "";

    return placeType;
}

function convertTrends(json jsonTrends) returns Trends[] {
    Trends [] trends = [];
    trends[0] = convertToTrends(jsonTrends[0]);
    return trends;
}

function convertToTrends(json jsonTrends) returns (Trends) {
    Trends trendList = {};
    trendList.trends = convertTrendList(jsonTrends.trends);
    trendList.locations = convertToLocations(jsonTrends.locations);
    trendList.createdAt = jsonTrends.created_at != null ? jsonTrends.created_at.toString() : "";

    return trendList;
}

function convertTrendList(json jsonTrends) returns Trend[] {
    Trend[] trendList = [];
    int i = 0;
    foreach jsonTrend in jsonTrends {
        trendList[i] = convertToTrend(jsonTrend);
        i = i +1;
    }
    return trendList;
}

function convertToTrend(json jsonTrend) returns (Trend) {
    Trend trend = {};
    trend.name = jsonTrend.name != null ? jsonTrend.name.toString() : "";
    trend.url = jsonTrend.url != null ? jsonTrend.url.toString() : "";
    trend.promotedContent = jsonTrend.promoted_content != null ? jsonTrend.promoted_content.toString() : "";
    trend.trendQuery = jsonTrend["query"] != null ? jsonTrend["query"].toString() : "";
    trend.tweetVolume = jsonTrend.tweet_volume != null ? convertToInt(jsonTrend.tweet_volume) : 0;

    return trend;
}
