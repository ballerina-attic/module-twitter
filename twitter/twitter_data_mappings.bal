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

function convertToStatus(json jsonStatus) returns Status|error {
    Status status = {};
    status.createdAt = jsonStatus.created_at != null ? jsonStatus.created_at.toString() : "";
    status.id = jsonStatus.id != null ? convertToInt(check jsonStatus.id) : 0;
    status.text = jsonStatus.text != null ? jsonStatus.text.toString() : "";
    status.'source = jsonStatus.'source != null ? jsonStatus.'source.toString() : "";
    status.truncated = jsonStatus.truncated != null ? check convertToBoolean(check jsonStatus.truncated) : false;
    status.inReplyToStatusId = jsonStatus.in_reply_to_status_id != null
                                    ? convertToInt(check jsonStatus.in_reply_to_status_id) : 0;
    status.favorited = jsonStatus.favorited != null ? check convertToBoolean(check jsonStatus.favorited) : false;
    status.retweeted = jsonStatus.retweeted != null ? check convertToBoolean(check jsonStatus.retweeted) : false;
    status.favouritesCount = jsonStatus.favourites_count != null ? convertToInt(check jsonStatus.favourites_count) : 0;
    status.retweetCount = jsonStatus.retweet_count != null ? convertToInt(check jsonStatus.retweet_count) : 0;
    status.lang = jsonStatus.lang != null ? jsonStatus.lang.toString() : "";
    status.geo = jsonStatus.geo != null ? check convertToGeoLocation(check jsonStatus.geo) : {};
    return status;
}

function convertToInt(json jsonVal) returns int {
    string stringVal = jsonVal.toString();
    if (stringVal != "") {
        var intVal = typedesc<int>.constructFrom(stringVal);
        if (intVal is int) {
            return intVal;
        } else {
            error err = error(TWITTER_ERROR_CODE, message = "Error occurred when converting " + stringVal + " to int");
            panic err;
        }
    } else {
        return 0;
    }
}

function convertToBoolean(json jsonVal) returns boolean|error {
    string stringVal = jsonVal.toString();
    return check typedesc<boolean>.constructFrom(stringVal);
}

function convertToFloat(json jsonVal) returns float {
    string stringVal = jsonVal.toString();
    var floatVal = typedesc<float>.constructFrom(stringVal);
    if (floatVal is float) {
        return floatVal;
    } else {
        error err = error(TWITTER_ERROR_CODE, message = "Error occurred when converting " + stringVal + " to float");
        panic err;
    }
}

function convertToGeoLocation(json jsonStatus) returns GeoLocation|error {
    GeoLocation geoLocation = {};
    geoLocation.latitude = jsonStatus.geo.latitude != null ? convertToFloat(check jsonStatus.geo.latitude) : 0.0;
    geoLocation.longitude = jsonStatus.geo.longitude != null ? convertToFloat(check jsonStatus.geo.longitude) : 0.0;
    return geoLocation;
}

function convertToStatuses(json[] jsonStatuses) returns Status[]|error {
    Status[] statuses = [];
    int i = 0;
    foreach json jsonStatus in jsonStatuses {
        statuses[i] = check convertToStatus(jsonStatus);
        i = i + 1;
    }
    return statuses;
}

function convertToLocations(json[] jsonLocations) returns Location[]|error {
    Location[] locations = [];
    int i = 0;
    foreach json jsonLocation in jsonLocations {
        locations[i] = check convertToLocation(jsonLocation);
        i = i + 1;
    }
    return locations;
}

function convertToLocation(json jsonLocation) returns Location|error {
    Location location = {};
    location.countryName = jsonLocation.country != null ? jsonLocation.country.toString() : "";
    location.countryCode = jsonLocation.countryCode != null ? jsonLocation.countryCode.toString() : "";
    location.name = jsonLocation.name != null ? jsonLocation.name.toString() : "";
    location.placeType = jsonLocation.placeType != null ? check convertToPlaceType(check jsonLocation.placeType) : {};
    location.url = jsonLocation.url != null ? jsonLocation.url.toString() : "";
    location.woeid = jsonLocation.woeid != null ? convertToInt(check jsonLocation.woeid) : 0;
    return location;
}

function convertToPlaceType(json jsonPlaceType) returns PlaceType|error {
    PlaceType placeType = {};
    placeType.code = jsonPlaceType.code != null ? convertToInt(check jsonPlaceType.code) : 0;
    placeType.name = jsonPlaceType.name != null ? jsonPlaceType.name.toString() : "";
    return placeType;
}

function convertTrends(json jsonTrends) returns Trends[]|error {
    Trends[] trends = [];
    if (jsonTrends is json[]) {
        trends[0] = check convertToTrends(jsonTrends[0]);
    }
    return trends;
}

function convertToTrends(json jsonTrends) returns Trends|error {
    Trends trendList = {};
    trendList.trends = check convertTrendList(<json[]>jsonTrends.trends);
    trendList.location = check convertToLocations(<json[]>jsonTrends.locations);
    trendList.createdAt = jsonTrends.created_at != null ? jsonTrends.created_at.toString() : "";
    return trendList;
}

function convertTrendList(json[] jsonTrends) returns Trend[]|error {
    Trend[] trendList = [];
    int i = 0;
    foreach json jsonTrend in jsonTrends {
        trendList[i] = check convertToTrend(jsonTrend);
        i = i + 1;
    }
    return trendList;
}

function convertToTrend(json jsonTrend) returns Trend|error {
    Trend trend = {};
    trend.name = jsonTrend.name != null ? jsonTrend.name.toString() : "";
    trend.url = jsonTrend.url != null ? jsonTrend.url.toString() : "";
    trend.promotedContent = jsonTrend.promoted_content != null ? jsonTrend.promoted_content.toString() : "";
    trend.trendQuery = jsonTrend.query != null ? jsonTrend.query.toString() : "";
    trend.tweetVolume = jsonTrend.tweet_volume != null ? convertToInt(check jsonTrend.tweet_volume) : 0;
    return trend;
}
