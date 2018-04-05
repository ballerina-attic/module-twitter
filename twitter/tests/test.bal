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
import ballerina/util;
import ballerina/config;
import ballerina/io;

string clientId = getConfigparam(config:getAsString("CLIENT_ID"));
string clientSecret = getConfigparam(config:getAsString("CLIENT_SECRET"));
string accessToken = getConfigparam(config:getAsString("ACCESS_TOKEN"));
string accessTokenSecret = getConfigparam(config:getAsString("ACCESS_TOKEN_SECRET"));
string tweetId;

endpoint TwitterEndpoint twitterEP {
    clientId:clientId,
    clientSecret:clientSecret,
    accessToken:accessToken,
    accessTokenSecret:accessTokenSecret,
    clientConfig:{}
};

@test:Config
function testTweet () {
    io:println("--------------Calling tweet----------------");
    string nonceString = util:uuid();
    time:Time time = time:currentTime();
    int currentTimeMills = time.time;
    string timeStamp = <string> (currentTimeMills/1000);
    string status = "Twitter connector test " + timeStamp;
    var tweetResponse = twitterEP -> tweet(status);

    match tweetResponse {
        Status twitterStatus => {
            tweetId = <string> twitterStatus.id;
            test:assertEquals(twitterStatus.text, status, msg = "Failed to call tweet()");
        }
        TwitterError err => {
            io:println(err.errorMessage);
            test:assertFail(msg = err.errorMessage);
        }
    }
}

@test:Config {
    dependsOn:["testTweet"]
}
function testReTweet () {
    io:println("--------------Calling retweet----------------");
    var tweetResponse = twitterEP -> retweet (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertTrue(twitterStatus.retweeted, msg = "Failed to call retweet()");
        }
        TwitterError err => {
            test:assertFail(msg = err.errorMessage);
        }
    }
}

@test:Config {
    dependsOn:["testReTweet"]
}
function testUnReTweet () {
    io:println("--------------Calling unretweet----------------");
    var tweetResponse = twitterEP -> unretweet (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertEquals(twitterStatus.id, <int> tweetId, msg = "Failed to call unretweet()");
        }
        TwitterError err => {
            test:assertFail(msg = err.errorMessage);
        }
    }
}

@test:Config
function testSearch () {
    io:println("--------------Calling search----------------");
    string queryStr = "twitter";
    var tweetResponse = twitterEP -> search (queryStr);

    match tweetResponse {
        Status[] twitterStatus => {
            test:assertNotEquals(twitterStatus, null, msg = "Failed to call search()");
        }
        TwitterError err => {
            test:assertFail(msg = err.errorMessage);
        }
    }
}

@test:Config {
    dependsOn:["testUnReTweet"]
}
function testShowStatus () {
    io:println("--------------Calling showStatus----------------");
    var tweetResponse = twitterEP -> showStatus (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertEquals(twitterStatus.id, <int> tweetId, msg = "Failed to call showStatus()");
        }
        TwitterError err => {
            test:assertFail(msg = err.errorMessage);
        }
    }
}

@test:Config {
    dependsOn:["testShowStatus"]
}
function testDestroyStatus () {
    io:println("--------------Calling destroyStatus----------------");
    var tweetResponse = twitterEP -> destroyStatus (tweetId);

    match tweetResponse {
        Status twitterStatus => {
            test:assertEquals(twitterStatus.id, <int> tweetId, msg = "Failed to call destroyStatus()");
        }
        TwitterError err => {
            test:assertFail(msg = err.errorMessage);
        }
    }
}

@test:Config
function testGetClosestTrendLocations () {
    io:println("--------------Calling getClosestTrendLocations----------------");
    string latitude = "34";
    string longitude = "67";
    var tweetResponse = twitterEP -> getClosestTrendLocations (latitude, longitude);

    match tweetResponse {
        Location [] response => {
            test:assertNotEquals(response, null, msg = "Failed to call getClosestTrendLocations()");
        }
        TwitterError err => {
            test:assertFail(msg = err.errorMessage);
        }
    }
}

@test:Config
function testGetTopTrendsByPlace () {
    io:println("--------------Calling getTopTrendsByPlace----------------");
    string locationId = "23424922";
    var tweetResponse = twitterEP -> getTopTrendsByPlace (locationId);

    match tweetResponse {
        Trends[] response => {
            test:assertNotEquals(response, null, msg = "Failed to call getTopTrendsByPlace()");
        }
        TwitterError err => {
            test:assertFail(msg = err.errorMessage);
        }
    }
}

function getConfigparam (string|null confParam) returns (string) {
    match confParam {
        string param => {
            return param;
        }
        null => {
            io:println("Empty value!");
            return "";
        }
    }
}