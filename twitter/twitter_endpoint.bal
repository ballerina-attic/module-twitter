//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
//

import ballerina/http;

# Twitter Client object.
# + twitterConnector - TwitterConnector Connector object
public type Client client object {

    public TwitterConnector twitterConnector;

    public function __init(TwitterConfiguration twitterConfig) {
        self.twitterConnector = new(TWITTER_API_URL, twitterConfig);
    }

    # Update the authenticated user's current status (If you want to provide attachment, you can use
    # mediaIds or attachmentUrl).
    # + status - The text of status update
    # + args - The user parameters as args
    # + return - If success, returns Status object, else returns error.
    public remote function tweet(string status, string... args) returns Status|error {
        return self.twitterConnector->tweet(status, args);
    }

    # Retweet a tweet.
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns error.
    public remote function retweet(int id) returns Status|error {
        return self.twitterConnector->retweet(id);
    }

    # Untweet a retweeted status.
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns error.
    public remote function unretweet(int id) returns Status|error {
        return self.twitterConnector->unretweet(id);
    }

    # Search for tweets.
    # + queryStr - Query string to retrieve the related tweets
    # + searchRequest - It contains optional params that is needed for search operation(tweetsCount)
    # + return - If success, Status[] object, else returns error
    public remote function search(string queryStr, SearchRequest searchRequest) returns Status[]|error {
        return self.twitterConnector->search(queryStr, searchRequest);
    }

    # Retrive a single status.
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns error
    public remote function showStatus(int id) returns Status|error {
        return self.twitterConnector->showStatus(id);
    }

    # Distroy a status.
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns error
    public remote function destroyStatus(int id) returns Status|error {
        return self.twitterConnector->destroyStatus(id);
    }

    # Retrive closest trend locations.
    # + lat - Latitude of the location
    # + long - Longitude of the location
    # + return - If success, returns Location[] object, else returns error
    public remote function getClosestTrendLocations(float lat, float long) returns Location[]|error {
        return self.twitterConnector->getClosestTrendLocations(lat, long);
    }

    # Retrive top trends by place.
    # + locationId - Where On Earth ID of the location to return trending information for
    # + return - If success, returns Trends[] object, else returns error
    public remote function getTopTrendsByPlace(int locationId) returns Trends[]|error {
        return self.twitterConnector->getTopTrendsByPlace(locationId);
    }
};

# Twitter Connector configurations can be setup here.
# + accessToken - The access token of the Twitter account
# + accessTokenSecret - The access token secret of the Twitter account
# + clientId - The consumer key of the Twitter account
# + clientSecret - The consumer secret of the Twitter account
# + clientConfig - Client endpoint configurations provided by the user
public type TwitterConfiguration record {
    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:ClientEndpointConfig clientConfig = {};
};
