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

function convertToStatus(json jsonStatus) returns Status {
    Status status = {};
    var createdAt = jsonStatus.created_at;
    if (createdAt is json) {
        status.createdAt = createdAt != null ? createdAt.toString() : "";
    }
    var id = jsonStatus.id;
    if (id is json) {
        status.id = id != null ? convertToInt(id) : 0;
    }
    var text = jsonStatus.text;
    if (text is json) {
        status.text = text != null ? text.toString() : "";
    }
    var sourceOut = jsonStatus.'source;
    if (sourceOut is json) {
        status.'source = sourceOut != null ? sourceOut.toString() : "";
    }
    var truncated = jsonStatus.truncated;
    if (truncated is json) {
        status.truncated = truncated != null ? convertToBoolean(truncated) : false;
    }
    var inReplyToStatusId = jsonStatus.in_reply_to_status_id;
    if (inReplyToStatusId is json) {
        status.inReplyToStatusId = inReplyToStatusId != null ? convertToInt(inReplyToStatusId) : 0;
    }
    var favorited = jsonStatus.favorited;
    if (favorited is json) {
        status.favorited = favorited != null ? convertToBoolean(favorited) : false;
    }
    var retweeted = jsonStatus.retweeted;
    if (retweeted is json) {
        status.retweeted = retweeted != null ? convertToBoolean(retweeted) : false;
    }
    var favouritesCount = jsonStatus.favourites_count;
    if (favouritesCount is json) {
        status.favouritesCount = favouritesCount != null ? convertToInt(favouritesCount) : 0;
    }
    var retweetCount = jsonStatus.retweet_count;
    if (retweetCount is json) {
        status.retweetCount = retweetCount != null ? convertToInt(retweetCount) : 0;
    }
    var lang = jsonStatus.lang;
    if (lang is json) {
        status.lang = lang != null ? lang.toString() : "";
    }
    var geo = jsonStatus.geo;
    if (geo is json) {
        status.geo = geo != null ? convertToGeoLocation(geo) : {};
    }
    return status;
}

function convertToInt(json jsonVal) returns int {
    var intVal = typedesc<int>.constructFrom(jsonVal);
    if (intVal is int) {
        return intVal;
    } else {
        error err = error(TWITTER_ERROR_CODE,
                          message = "Error occurred when converting " + jsonVal.toString() + " to int");
        panic err;
    }
}

function convertToBoolean(json jsonVal) returns boolean {
    var booleanVal = typedesc<boolean>.constructFrom(jsonVal);
    if (booleanVal is boolean) {
        return booleanVal;
    } else {
        error err = error(TWITTER_ERROR_CODE,
                         message = "Error occurred when converting " + jsonVal.toString() + " to boolean");
        panic err;
    }
}

function convertToFloat(json jsonVal) returns float {
    var floatVal = typedesc<float>.constructFrom(jsonVal);
    if (floatVal is float) {
        return floatVal;
    } else {
        error err = error(TWITTER_ERROR_CODE,
                          message = "Error occurred when converting " + jsonVal.toString() + " to float");
        panic err;
    }
}

function convertToGeoLocation(json jsonStatus) returns GeoLocation {
    GeoLocation geoLocation = {};
    var latitude = jsonStatus.geo.latitude;
    if (latitude is json) {
        geoLocation.latitude = latitude != null ? convertToFloat(latitude) : 0.0;
    }
    var longitude = jsonStatus.geo.longitude;
    if (longitude is json) {
        geoLocation.longitude = longitude != null ? convertToFloat(longitude) : 0.0;
    }
    return geoLocation;
}

function convertToStatuses(json[] jsonStatuses) returns Status[] {
    Status[] statuses = [];
    int i = 0;
    foreach json jsonStatus in jsonStatuses {
        statuses[i] = convertToStatus(jsonStatus);
        i = i + 1;
    }
    return statuses;
}

function convertToLocations(json[] jsonLocations) returns Location[] {
    Location[] locations = [];
    int i = 0;
    foreach json jsonLocation in jsonLocations {
        locations[i] = convertToLocation(jsonLocation);
        i = i + 1;
    }
    return locations;
}

function convertToLocation(json jsonLocation) returns Location {
    Location location = {};
    var countryName = jsonLocation.country;
    if (countryName is json) {
       location.countryName = countryName != null ? countryName.toString() : "";
    }
    var countryCode = jsonLocation.countryCode;
    if (countryCode is json) {
       location.countryCode = countryCode != null ? countryCode.toString() : "";
    }
    var name = jsonLocation.name;
    if (name is json) {
       location.name = name != null ? name.toString() : "";
    }
    var placeType = jsonLocation.placeType;
    if (placeType is json) {
       location.placeType = placeType != null ? convertToPlaceType(placeType) : {};
    }
    var url = jsonLocation.url;
    if (url is json) {
       location.url = url != null ? url.toString() : "";
    }
    var woeid = jsonLocation.woeid;
    if (woeid is json) {
       location.woeid = woeid != null ? convertToInt(woeid) : 0;
    }
    return location;
}

function convertToPlaceType(json jsonPlaceType) returns PlaceType {
    PlaceType placeType = {};
    var code = jsonPlaceType.code;
    if (code is json) {
       placeType.code = code != null ? convertToInt(code) : 0;
    }
    var name = jsonPlaceType.name;
    if (name is json) {
       placeType.name = name != null ? name.toString() : "";
    }
    return placeType;
}

function convertTrends(json jsonTrends) returns Trends[] {
    Trends[] trends = [];
    if (jsonTrends is json[]) {
        trends[0] = convertToTrends(jsonTrends[0]);
    }
    return trends;
}

function convertToTrends(json jsonTrends) returns Trends {
    Trends trendList = {};
    trendList.trends = convertTrendList(<json[]>jsonTrends.trends);
    trendList.location = convertToLocations(<json[]>jsonTrends.locations);
    var createdAt = jsonTrends.created_at;
    if (createdAt is json) {
       trendList.createdAt = createdAt != null ? createdAt.toString() : "";
    }
    return trendList;
}

function convertTrendList(json[] jsonTrends) returns Trend[] {
    Trend[] trendList = [];
    int i = 0;
    foreach json jsonTrend in jsonTrends {
        trendList[i] = convertToTrend(jsonTrend);
        i = i + 1;
    }
    return trendList;
}

function convertToTrend(json jsonTrend) returns Trend {
    Trend trend = {};
    var name = jsonTrend.name;
    if (name is json) {
       trend.name = name != null ? name.toString() : "";
    }
    var url = jsonTrend.url;
    if (url is json) {
       trend.url = url != null ? url.toString() : "";
    }
    var promotedContent = jsonTrend.promoted_content;
    if (promotedContent is json) {
       trend.promotedContent = promotedContent != null ? promotedContent.toString() : "";
    }
    var trendQuery = jsonTrend.query;
    if (trendQuery is json) {
       trend.trendQuery = trendQuery != null ? trendQuery.toString() : "";
    }
    var tweetVolume = jsonTrend.tweet_volume;
    if (tweetVolume is json) {
       trend.tweetVolume = tweetVolume != null ? convertToInt(tweetVolume) : 0;
    }
    return trend;
}
