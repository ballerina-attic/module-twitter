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

import ballerina/test;
import ballerina/time;
import ballerina/system;
import ballerina/config;
import ballerina/io;

string testClientId = config:getAsString("CLIENT_ID");
string testClientSecret = config:getAsString("CLIENT_SECRET");
string testAccessToken = config:getAsString("ACCESS_TOKEN");
string testAccessTokenSecret = config:getAsString("ACCESS_TOKEN_SECRET");
int tweetId;

endpoint Client twitterClient {
    clientId: testClientId,
    clientSecret: testClientSecret,
    accessToken: testAccessToken,
    accessTokenSecret: testAccessTokenSecret
};

@test:Config
function testTweet() {
    io:println("--------------Calling tweet----------------");
    time:Time time = time:currentTime();
    int currentTimeMills = time.time;
    string currentTimeStamp = <string>(currentTimeMills / 1000);
    string status = "Twitter connector test " + currentTimeStamp;
    var tweetResponse = twitterClient->tweet(status);

    match tweetResponse {
        Status twitterStatus => {
            tweetId = twitterStatus.id;
            string text = twitterStatus.text;
            test:assertTrue(text.contains(status), msg = "Failed to call tweet()");
        }
        error err => {
            io:println(err.message);
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testTweet"]
}
function testReTweet() {
    io:println("--------------Calling retweet----------------");
    var tweetResponse = twitterClient->retweet (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertTrue(twitterStatus.retweeted, msg = "Failed to call retweet()");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testReTweet"]
}
function testUnReTweet() {
    io:println("--------------Calling unretweet----------------");
    var tweetResponse = twitterClient->unretweet (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertEquals(twitterStatus.id, tweetId, msg = "Failed to call unretweet()");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config
function testSearch() {
    io:println("--------------Calling search----------------");
    string queryStr = "twitter";
    SearchRequest request = {
        tweetsCount:"100"
    };
    var tweetResponse = twitterClient->search (queryStr, request);

    match tweetResponse {
        Status[] twitterStatus => {
            test:assertNotEquals(twitterStatus, null, msg = "Failed to call search()");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testUnReTweet"]
}
function testShowStatus() {
    io:println("--------------Calling showStatus----------------");
    var tweetResponse = twitterClient->showStatus (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertEquals(twitterStatus.id, tweetId, msg = "Failed to call showStatus()");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testShowStatus"]
}
function testDestroyStatus() {
    io:println("--------------Calling destroyStatus----------------");
    var tweetResponse = twitterClient->destroyStatus (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertEquals(twitterStatus.id, tweetId, msg = "Failed to call destroyStatus()");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config
function testGetClosestTrendLocations() {
    io:println("--------------Calling getClosestTrendLocations----------------");
    float latitude = 34.0;
    float longitude = 67.0;
    var tweetResponse = twitterClient->getClosestTrendLocations (latitude, longitude);

    match tweetResponse {
        Location[] response => {
            test:assertNotEquals(response, null, msg = "Failed to call getClosestTrendLocations()");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config
function testGetTopTrendsByPlace() {
    io:println("--------------Calling getTopTrendsByPlace----------------");
    int locationId = 23424922;
    var tweetResponse = twitterClient->getTopTrendsByPlace (locationId);

    match tweetResponse {
        Trends[] response => {
            test:assertNotEquals(response, null, msg = "Failed to call getTopTrendsByPlace()");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

