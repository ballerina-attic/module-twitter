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

# Define the Twitter connector.
# + accessToken - The access token of the Twitter account
# + accessTokenSecret - The access token secret of the Twitter account
# + clientId - The consumer key of the Twitter account
# + clientSecret - The consumer secret of the Twitter account
# + clientEndpoint - HTTP client endpoint
public type TwitterConnector object {

    public string accessToken;
    public string accessTokenSecret;
    public string clientId;
    public string clientSecret;
    public http:Client clientEndpoint = new;

    # Update the authenticated user's current status (If you want to provide attachment, you can use
    # mediaIds or attachmentUrl).
    # + status - The text of status update
    # + return - If success, returns Status object, else returns TwitterError object.
    public function tweet(string status, string... args) returns Status|TwitterError;

    # Retweet a tweet.
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns TwitterError object.
    public function retweet(int id) returns Status|TwitterError;

    # Untweet a retweeted status.
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns TwitterError object
    public function unretweet(int id) returns Status|TwitterError;

    # Search for tweets.
    # + queryStr - Query string to retrieve the related tweets
    # + searchRequest - It contains optional params that is needed for search operation(tweetsCount)
    # + return - If success, Status[] object, else returns TwitterError object
    public function search(string queryStr, SearchRequest searchRequest) returns Status[]|TwitterError;

    # Retrive a single status.
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns TwitterError object
    public function showStatus(int id) returns Status|TwitterError;

    # Distroy a status.
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns TwitterError object
    public function destroyStatus(int id) returns Status|TwitterError;

    # Retrive closest trend locations.
    # + lat - Latitude of the location
    # + long - Longitude of the location
    # + return - If success, returns Location[] object, else returns TwitterError object
    public function getClosestTrendLocations(float lat, float long) returns Location[]|TwitterError;

    # Retrive top trends by place.
    # + locationId - Where On Earth ID of the location to return trending information for
    # + return - If success, returns Trends[] object, else returns TwitterError object
    public function getTopTrendsByPlace(int locationId) returns Trends[]|TwitterError;
};

# Twitter Client object.
# + twitterConfig - Twitter connector configurations
# + twitterConnector - TwitterConnector Connector object
public type Client object {

    public TwitterConfiguration twitterConfig = {};
    public TwitterConnector twitterConnector = new;

    # Twitter connector endpoint initialization function.
    # + config - Twitter connector configuration
    public function init(TwitterConfiguration config);

    # Return the Twitter connector client.
    # + return - Twitter connector client
    public function getCallerActions() returns TwitterConnector;

};

# Twitter connector configurations can be setup here.
# + uri - The Twitter API URL
# + accessToken - The access token of the Twitter account
# + accessTokenSecret - The access token secret of the Twitter account
# + clientId - The consumer key of the Twitter account
# + clientSecret - The consumer secret of the Twitter account
# + clientConfig - Client endpoint configurations provided by the user
public type TwitterConfiguration record {
    string uri;
    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:ClientEndpointConfig clientConfig = {};
};

# Define the status.
# + createdAt - Created time of the status
# + id - Id of the status
# + text - Text message of the status
# + source - Source app of the status
# + truncated - Whether the status is truncated or not
# + inReplyToStatusId - The ID of an existing status that the update is in reply to
# + geo - Geo location details (longitude and latitude)
# + favorited - Whether the status is favorited or not
# + retweeted - Whether the status is retweeted or not
# + favouritesCount - Count of the favourites
# + retweetCount - Count of the retweeted status
# + lang - Language
public type Status record {
    string createdAt;
    int id;
    string text;
    string source;
    boolean truncated;
    int inReplyToStatusId;
    GeoLocation geo;
    boolean favorited;
    boolean retweeted;
    int favouritesCount;
    int retweetCount;
    string lang;
};

# Define the geo location details.
# + latitude - Latitude of the location
# + longitude - Longitude of the location
public type GeoLocation record {
    float latitude;
    float longitude;
};

# Define the location details.
# + woeid - Where On Earth IDentifier
# + countryName - Country name
# + countryCode - Country code
# + name - Name of the location
# + placeType - Longitude of the location
# + url - Location url
public type Location record {
    int woeid;
    string countryName;
    string countryCode;
    string name;
    PlaceType placeType;
    string url;
};

# Define the place type.
# + name - Name of the place
# + code - Location code of the place
public type PlaceType record {
    string name;
    int code;
};

# Define the trends type.
# + trends - List of Trending object
# + locations - List of Locations object
# + createdAt - Created time
public type Trends record {
    Trend[] trends;
    Location[] locations;
    string createdAt;
};

# Define the trend type.
# + name - Name of trend object
# + url - Url of trend object
# + trendQuery - Query of the trend object
# + promotedContent - Promoted content
# + tweetVolume - Volume of the tweet
public type Trend record {
    string name;
    string url;
    string trendQuery;
    string promotedContent;
    int tweetVolume;
};

# Define the search request.
# + tweetsCount - The number of tweets to return per page, up to a maximum of 100
public type SearchRequest record {
    string tweetsCount;
};

# Twitter Client Error.
# + message - Error message of the response
# + cause - The error which caused the Twitter error
# + statusCode - Status code of the response
public type TwitterError record {
    string message;
    error? cause;
    int statusCode;
};
