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

@Description {value: "Struct to define the Twitter connector."}
public type TwitterConnector object {
    public {
        string accessToken;
        string accessTokenSecret;
        string clientId;
        string clientSecret;
        http:ClientEndpoint clientEndpoint = new;
    }

    public function tweet (string status) returns Status | TwitterError;
    public function retweet (string id) returns Status | TwitterError;
    public function unretweet (string id) returns Status | TwitterError;
    public function search (string queryStr) returns Status[] | TwitterError;
    public function showStatus (string id) returns Status | TwitterError;
    public function destroyStatus (string id) returns Status | TwitterError;
    public function getClosestTrendLocations (string lat, string long) returns Location [] | TwitterError;
    public function getTopTrendsByPlace (string locationId) returns Trends[] | TwitterError;
};

@Description {value:"Twitter Endpoint struct."}
@Field {value: "twitterConfig: Twitter connector configurations"}
@Field {value: "twitterConnector: Twitter Connector object"}
public type TwitterClient object {
    public {
        TwitterConfiguration twitterConfig = {};
        TwitterConnector twitterConnector = new;
    }

    @Description {value: "Twitter connector endpoint initialization function"}
    @Param {value: "TwitterConfiguration: Twitter connector configuration"}
    public function init (TwitterConfiguration twitterConfig);

    @Description {value: "Register Twitter connector endpoint"}
    @Param {value: "typedesc: Accepts types of data (int, float, string, boolean, etc)"}
    public function register (typedesc serviceType);

    @Description {value: "Start Twitter connector endpoint"}
    public function start ();

    @Description {value: "Return the Twitter connector client"}
    @Return {value: "Twitter connector client"}
    public function getClient () returns TwitterConnector;

    @Description {value: "Stop Twitter connector client"}
    public function stop ();
};

@Description {value:"Twitter connector configurations can be setup here"}
@Field {value: "uri: The Twitter API URL"}
@Field {value: "accessToken: The access token of the Twitter account"}
@Field {value: "accessTokenSecret: The access token secret of the Twitter account"}
@Field {value: "clientId: The consumer key of the Twitter account"}
@Field {value: "clientSecret: The consumer secret of the Twitter account"}
@Field {value: "clientConfig: Client endpoint configurations provided by the user"}
public type TwitterConfiguration {
    string uri;
    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:ClientEndpointConfiguration clientConfig = {};
};

@Description {value: "Struct to define the Twitter connector."}
public struct TwitterConnector {
    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:ClientEndpoint clientEndpoint;
}

@Description {value:"Twitter Endpoint struct."}
public struct TwitterEndpoint {
    TwitterConfiguration twitterConfig;
    TwitterConnector twitterConnector;
}

@Description {value:"Struct to set the twitter configuration."}
public struct TwitterConfiguration {
    string uri;
    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:ClientEndpointConfiguration clientConfig;
}

@Description {value: "Struct to define the status."}
public type Status {
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
};

@Description {value: "Struct to define the geo location details."}
public type GeoLocation {
    float latitude;
    float longitude;
};

@Description {value: "Struct to define the location details."}
public type Location {
    int woeid;
    string countryName;
    string countryCode;
    string name;
    PlaceType placeType;
    string url;
};

@Description {value: "Struct to define the place type."}
public type PlaceType {
    string name;
    int code;
};

@Description {value: "Struct to define the trends type."}
public type Trends {
    Trend[] trends;
    Location[] locations;
    string createdAt;
};

@Description {value: "Struct to define the trend type."}
public type Trend {
    string name;
    string url;
    string trendQuery;
    string promotedContent;
    int tweetVolume;
};

@Description {value: "Struct to define the error."}
public type TwitterError {
    int statusCode;
    string errorMessage;
};