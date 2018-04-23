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

string clientId = config:getAsString("CLIENT_ID");
string clientSecret = config:getAsString("CLIENT_SECRET");
string accessToken = config:getAsString("ACCESS_TOKEN");
string accessTokenSecret = config:getAsString("ACCESS_TOKEN_SECRET");
string tweetId;

endpoint Client twitterClient {
    clientId:clientId,
    clientSecret:clientSecret,
    accessToken:accessToken,
    accessTokenSecret:accessTokenSecret,
    clientConfig:{}
};

@test:Config
function testTweet () {
    io:println("--------------Calling tweet----------------");
    string nonceString = system:uuid();
    time:Time time = time:currentTime();
    int currentTimeMills = time.time;
    string timeStamp = <string> (currentTimeMills/1000);
    string status = "Twitter connector test " + timeStamp;
    var tweetResponse = twitterClient->tweet(status, "987982473731555328", "");

    match tweetResponse {
        Status twitterStatus => {
            tweetId = <string> twitterStatus.id;
            string text = twitterStatus.text;
            test:assertTrue(text.contains(status), msg = "Failed to call tweet()");
        }
        TwitterError err => {
            io:println(err.message);
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn:["testTweet"]
}
function testReTweet () {
    io:println("--------------Calling retweet----------------");
    var tweetResponse = twitterClient->retweet (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertTrue(twitterStatus.retweeted, msg = "Failed to call retweet()");
        }
        TwitterError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn:["testReTweet"]
}
function testUnReTweet () {
    io:println("--------------Calling unretweet----------------");
    var tweetResponse = twitterClient->unretweet (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertEquals(twitterStatus.id, <int> tweetId, msg = "Failed to call unretweet()");
        }
        TwitterError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config
function testSearch () {
    io:println("--------------Calling search----------------");
    string queryStr = "twitter";
    var tweetResponse = twitterClient->search (queryStr);

    match tweetResponse {
        Status[] twitterStatus => {
            test:assertNotEquals(twitterStatus, null, msg = "Failed to call search()");
        }
        TwitterError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn:["testUnReTweet"]
}
function testShowStatus () {
    io:println("--------------Calling showStatus----------------");
    var tweetResponse = twitterClient->showStatus (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertEquals(twitterStatus.id, <int> tweetId, msg = "Failed to call showStatus()");
        }
        TwitterError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn:["testShowStatus"]
}
function testDestroyStatus () {
    io:println("--------------Calling destroyStatus----------------");
    var tweetResponse = twitterClient->destroyStatus (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertEquals(twitterStatus.id, <int> tweetId, msg = "Failed to call destroyStatus()");
        }
        TwitterError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config
function testGetClosestTrendLocations () {
    io:println("--------------Calling getClosestTrendLocations----------------");
    string latitude = "34";
    string longitude = "67";
    var tweetResponse = twitterClient->getClosestTrendLocations (latitude, longitude);

    match tweetResponse {
        Location [] response => {
            test:assertNotEquals(response, null, msg = "Failed to call getClosestTrendLocations()");
        }
        TwitterError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config
function testGetTopTrendsByPlace () {
    io:println("--------------Calling getTopTrendsByPlace----------------");
    string locationId = "23424922";
    var tweetResponse = twitterClient->getTopTrendsByPlace (locationId);

    match tweetResponse {
        Trends[] response => {
            test:assertNotEquals(response, null, msg = "Failed to call getTopTrendsByPlace()");
        }
        TwitterError err => {
            test:assertFail(msg = err.message);
        }
    }
}

