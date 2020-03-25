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

import ballerina/config;
import ballerina/io;
import ballerina/test;
import ballerina/time;
import ballerina/stringutils;

string testClientId = config:getAsString("CLIENT_ID");
string testClientSecret = config:getAsString("CLIENT_SECRET");
string testAccessToken = config:getAsString("ACCESS_TOKEN");
string testAccessTokenSecret = config:getAsString("ACCESS_TOKEN_SECRET");
int tweetId = 0;

TwitterConfiguration twitterConfig = {
    clientId: testClientId,
    clientSecret: testClientSecret,
    accessToken: testAccessToken,
    accessTokenSecret: testAccessTokenSecret
};

Client twitterClient = new(twitterConfig);

@test:Config {}
function testTweet() {
    time:Time time = time:currentTime();
    int currentTimeMills = time.time;
    string currentTimeStamp = io:sprintf("%s", currentTimeMills / 1000);
    string status = "Twitter connector test " + currentTimeStamp;
    var tweetResponse = twitterClient->tweet(status);

    if (tweetResponse is Status) {
        tweetId = <@untainted> tweetResponse.id;
        test:assertTrue(stringutils:contains(tweetResponse.text, status), "Failed to call tweet()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {
    dependsOn: ["testTweet"]
}
function testReTweet() {
    var tweetResponse = twitterClient->retweet(tweetId);
    if (tweetResponse is Status) {
        test:assertTrue(tweetResponse.retweeted, "Failed to call retweet()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {
    dependsOn: ["testReTweet"]
}
function testUnReTweet() {
    var tweetResponse = twitterClient->unretweet(tweetId);
    if (tweetResponse is Status) {
        test:assertEquals(tweetResponse.id, tweetId, "Failed to call unretweet()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {}
function testSearch() {
    string queryStr = "twitter";
    SearchRequest request = {
        tweetsCount:"100"
    };
    var tweetResponse = twitterClient->search(queryStr, request);

    if (tweetResponse is error) {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    } else {
        test:assertTrue(tweetResponse.length() > 0, "Failed to call search()");
    }
}

@test:Config {
    dependsOn: ["testUnReTweet"]
}
function testShowStatus() {
    var tweetResponse = twitterClient->showStatus(tweetId);
    if (tweetResponse is Status) {
        test:assertEquals(tweetResponse.id, tweetId, "Failed to call showStatus()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {
    dependsOn: ["testShowStatus"]
}
function testDestroyStatus() {
    var tweetResponse = twitterClient->destroyStatus(tweetId);
    if (tweetResponse is Status) {
        test:assertEquals(tweetResponse.id, tweetId, "Failed to call destroyStatus()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {}
function testGetClosestTrendLocations() {
    float latitude = 34.0;
    float longitude = 67.0;
    var tweetResponse = twitterClient->getClosestTrendLocations(latitude, longitude);
    if (tweetResponse is error) {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    } else {
        test:assertTrue(tweetResponse.length() > 0, "Failed to call getClosestTrendLocations()");
    }
}

@test:Config {}
function testGetTopTrendsByPlace() {
    int locationId = 23424922;
    var tweetResponse = twitterClient->getTopTrendsByPlace (locationId);
    if (tweetResponse is error) {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    } else {
        test:assertTrue(tweetResponse.length() > 0, "Failed to call getTopTrendsByPlace()");
    }
}
