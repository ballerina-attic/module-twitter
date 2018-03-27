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

package twitter;

transformer <json jsonStatus, Status status> convertToStatus() {
    status.createdAt = jsonStatus.created_at != null ? jsonStatus.created_at.toString() : "";
    status.id = jsonStatus.id != null ? <int, convertToInt()> jsonStatus.id : 0;
    status.text = jsonStatus.text != null ? jsonStatus.text.toString() : "";
    status.source = jsonStatus.source != null ? jsonStatus.source.toString() : "";
    status.truncated = jsonStatus.truncated != null ? <boolean , convertToBoolean()> jsonStatus.truncated : false;
    status.inReplyToStatusId = jsonStatus.in_reply_to_status_id != null ?
                               <int, convertToInt()> jsonStatus.in_reply_to_status_id : 0;
    status.inReplyToUserId = jsonStatus.in_reply_to_user_id != null ?
                             <int, convertToInt()> jsonStatus.in_reply_to_user_id : 0;
    status.inReplyToScreenName = jsonStatus.in_reply_to_screen_name != null ?
                                 jsonStatus.in_reply_to_screen_name.toString() : "";
    status.favorited = jsonStatus.favorited != null ? <boolean , convertToBoolean()> jsonStatus.favorited : false;
    status.retweeted = jsonStatus.retweeted != null ? <boolean , convertToBoolean()> jsonStatus.retweeted : false;
    status.favouritesCount = jsonStatus.favourites_count != null ?
                             <int , convertToInt()> jsonStatus.favourites_count : 0;
    status.retweetCount = jsonStatus.retweet_count != null ? <int , convertToInt()> jsonStatus.retweet_count : 0;
    status.lang = jsonStatus.lang != null ? jsonStatus.lang.toString() : "";
    status.geo = jsonStatus.geo != null ? <GeoLocation, convertToGeoLocation()> jsonStatus.geo : {};
}

transformer <json jsonVal, int intVal> convertToInt() {
    intVal =? <int> jsonVal.toString();
}

transformer <json jsonVal, boolean booleanVal> convertToBoolean() {
    booleanVal = <boolean> jsonVal.toString();
}

transformer <json jsonVal, float floatVal> convertToFloat() {
    floatVal =? <float> jsonVal;
}

transformer <json jsonStatus, GeoLocation geoLocation> convertToGeoLocation() {
    geoLocation.latitude = <float , convertToFloat()> jsonStatus.geo.latitude;
    geoLocation.longitude = <float , convertToFloat()> jsonStatus.geo.longitude;
}

function convertToStatuses(json jsonStatuses) returns Status[] {
    Status[] statuses = [];
    int i = 0;
    foreach jsonStatus in jsonStatuses {
        statuses[i] = <Status, convertToStatus()> jsonStatus;
        i = i +1;
    }
    return statuses;
}

function convertToLocations(json jsonLocations) returns Location[] {
    Location[] locations = [];
    int i = 0;
    foreach jsonLocation in jsonLocations {
        locations[i] = <Location, convertToLocation()> jsonLocation;
        i = i +1;
    }
    return locations;
}

transformer <json jsonLocation, Location location> convertToLocation() {
    location.countryName =  jsonLocation.country != null ? jsonLocation.country.toString() : "";
    location.countryCode =  jsonLocation.countryCode != null ? jsonLocation.countryCode.toString() : "";
    location.name =  jsonLocation.name != null ? jsonLocation.name.toString() : "";
    location.placeType =  jsonLocation.placeType != null ? <PlaceType, convertToPlaceType()>jsonLocation.placeType : {};
    location.url =  jsonLocation.url != null ? jsonLocation.url.toString() : "";
    location.woeid = <int , convertToInt()> jsonLocation.woeid;
}

transformer <json jsonPlaceType, PlaceType placeType> convertToPlaceType() {
    placeType.code = <int , convertToInt()> jsonPlaceType.code;
    placeType.name = jsonPlaceType.name.toString();
}

function convertTrends(json jsonTrends) returns Trends[] {
    Trends [] trends = [];
    trends[0] = <Trends, convertToTrends()> jsonTrends[0];
    return trends;
}

transformer <json jsonTrends, Trends trendList> convertToTrends() {
    trendList.trends = jsonTrends.trends != null ? convertTrendList(jsonTrends.trends) : [];
    trendList.locations = jsonTrends.locations != null ? convertToLocations(jsonTrends.locations) : [];
    trendList.createdAt = jsonTrends.created_at != null ? jsonTrends.created_at.toString() : "";
}

function convertTrendList(json jsonTrends) returns Trend[] {
    Trend[] trendList = [];
    int i = 0;
    foreach jsonTrend in jsonTrends {
        trendList[i] = <Trend, convertToTrend()> jsonTrend;
        i = i +1;
    }
    return trendList;
}

transformer <json jsonTrend, Trend trend> convertToTrend() {
    trend.name = jsonTrend.name != null ? jsonTrend.name.toString() : "";
    trend.url = jsonTrend.url != null ? jsonTrend.url.toString() : "";
    trend.promotedContent = jsonTrend.promoted_content != null ? jsonTrend.promoted_content.toString() : "";
    trend.trendQuery = jsonTrend["query"] != null ? jsonTrend["query"].toString() : "";
    trend.tweetVolume = jsonTrend.tweet_volume != null ? <int, convertToInt()> jsonTrend.tweet_volume : 0;
}