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

documentation {Struct to define the Twitter connector}
public type TwitterConnector object {
    public {
        string accessToken;
        string accessTokenSecret;
        string clientId;
        string clientSecret;
        http:Client clientEndpoint = new;
    }

    documentation {Update the authenticated user's current status (If you want to provide attachment, you can use
        mediaIds or attachmentUrl)
        P{{status}} The text of status update
        returns Status object if successful else Error occured during HTTP client invocation.}
    public function tweet (string status, string... args) returns Status | TwitterError;

    documentation {Retweet a tweet
        P{{id}} The numerical ID of the desired status
        returns Status object if successful else Error occured during HTTP client invocation.}
    public function retweet (string id) returns Status | TwitterError;

    documentation {Untweet a retweeted status
        P{{id}} The numerical ID of the desired status
        returns Status object if successful else Error occured during HTTP client invocation.}
    public function unretweet (string id) returns Status | TwitterError;

    documentation {Search for tweets
        P{{queryStr}} Query string to retrieve the related tweets
        returns Status[] object if successful else Error occured during HTTP client invocation.}
    public function search (string queryStr) returns Status[] | TwitterError;

    documentation {Retrive a single status
        P{{id}} The numerical ID of the desired status
        returns Status object if successful else Error occured during HTTP client invocation.}
    public function showStatus (string id) returns Status | TwitterError;

    documentation {Distroy a status
        P{{id}} The numerical ID of the desired status
        returns Status object if successful else Error occured during HTTP client invocation.}
    public function destroyStatus (string id) returns Status | TwitterError;

    documentation {Retrive closest trend locations
        P{{lat}} Latitude of the location
        P{{long}} Longitude of the location
        returns Location[] object if successful else Error occured during HTTP client invocation.}
    public function getClosestTrendLocations (string lat, string long) returns Location [] | TwitterError;

    documentation {Retrive top trends by place
        P{{locationId}} Where On Earth ID of the location to return trending information for
        returns Trends[] object if successful else Error occured during HTTP client invocation.}
    public function getTopTrendsByPlace (string locationId) returns Trends[] | TwitterError;
};

documentation {Twitter Client object
    F{{twitterConfig}} Twitter connector configurations
    F{{twitterConnector}} twitterConnector Connector object
}
public type Client object {
    public {
        TwitterConfiguration twitterConfig = {};
        TwitterConnector twitterConnector = new;
    }

    documentation {Twitter connector endpoint initialization function
        P{{twitterConfig}} Twitter connector configuration
    }
    public function init (TwitterConfiguration twitterConfig);

    documentation {Return the Twitter connector client
        returns Twitter connector client
    }
    public function getClient () returns TwitterConnector;

};

documentation {Twitter connector configurations can be setup here
    F{{uri}} The Twitter API URL
    F{{accessToken}} The access token of the Twitter account
    F{{accessTokenSecret}} The access token secret of the Twitter account
    F{{clientId}} The consumer key of the Twitter account
    F{{clientSecret}} The consumer secret of the Twitter account
    F{{clientConfig}} Client endpoint configurations provided by the user
}
public type TwitterConfiguration {
    string uri;
    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:ClientEndpointConfig clientConfig = {};
};

documentation {Struct to define the status}
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

documentation {Struct to define the geo location details}
public type GeoLocation {
    float latitude;
    float longitude;
};

documentation {Struct to define the location details}
public type Location {
    int woeid;
    string countryName;
    string countryCode;
    string name;
    PlaceType placeType;
    string url;
};

documentation {Struct to define the place type}
public type PlaceType {
    string name;
    int code;
};

documentation {Struct to define the trends type}
public type Trends {
    Trend[] trends;
    Location[] locations;
    string createdAt;
};

documentation {Struct to define the trend type}
public type Trend {
    string name;
    string url;
    string trendQuery;
    string promotedContent;
    int tweetVolume;
};

documentation {Struct to define the error}
public type TwitterError {
    string message;
    error? cause;
    int statusCode;
};
