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