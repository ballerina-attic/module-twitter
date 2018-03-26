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

@Description {value: "Struct to define the status."}
public struct Status {
    string createdAt;
    int id;
    string text;
    string source;
    boolean truncated;
    int inReplyToStatusId;
    int inReplyToUserId;
    string inReplyToScreenName;
    GeoLocation geo;
    boolean favorited;
    boolean retweeted;
    int favouritesCount;
    int retweetCount;
    string lang;
}

@Description {value: "Struct to define the geo location details."}
public struct GeoLocation {
    float latitude;
    float longitude;
}

@Description {value: "Struct to define the error."}
public struct TwitterError {
    int statusCode;
    string errorMessage;
}