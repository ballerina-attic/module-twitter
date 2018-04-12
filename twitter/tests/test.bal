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

string clientId = config:getAsString("CLIENT_ID") but { () => "" };
string clientSecret = config:getAsString("CLIENT_SECRET") but { () => "" };
string accessToken = config:getAsString("ACCESS_TOKEN") but { () => "" };
string accessTokenSecret = config:getAsString("ACCESS_TOKEN_SECRET") but { () => "" };
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
    string nonceString = util:uuid();
    time:Time time = time:currentTime();
    int currentTimeMills = time.time;
    string timeStamp = <string> (currentTimeMills/1000);
    string status = "Twitter connector test " + timeStamp;
    Status twitterStatus = check twitterClient -> tweet(status, "984337514692427776", "");
    tweetId = <string> twitterStatus.id;
    string text = twitterStatus.text;
    test:assertTrue(text.contains(status), msg = "Failed to call tweet()");
}

@test:Config {
    dependsOn:["testTweet"]
}
function testReTweet () {
    io:println("--------------Calling retweet----------------");
    Status twitterStatus = check twitterClient -> retweet (tweetId);
    test:assertTrue(twitterStatus.retweeted, msg = "Failed to call retweet()");
}

@test:Config {
    dependsOn:["testReTweet"]
}
function testUnReTweet () {
    io:println("--------------Calling unretweet----------------");
    Status twitterStatus = check twitterClient -> unretweet (tweetId);
    test:assertEquals(twitterStatus.id, <int> tweetId, msg = "Failed to call unretweet()");
}

@test:Config
function testSearch () {
    io:println("--------------Calling search----------------");
    string queryStr = "twitter";
    Status[] twitterStatus = check twitterClient -> search (queryStr);
    test:assertNotEquals(twitterStatus, null, msg = "Failed to call search()");
}

@test:Config {
    dependsOn:["testUnReTweet"]
}
function testShowStatus () {
    io:println("--------------Calling showStatus----------------");
    Status twitterStatus = check twitterClient -> showStatus (tweetId);
    test:assertEquals(twitterStatus.id, <int> tweetId, msg = "Failed to call showStatus()");
}

@test:Config {
    dependsOn:["testShowStatus"]
}
function testDestroyStatus () {
    io:println("--------------Calling destroyStatus----------------");
    Status twitterStatus = check twitterClient -> destroyStatus (tweetId);
    test:assertEquals(twitterStatus.id, <int> tweetId, msg = "Failed to call destroyStatus()");
}

@test:Config
function testGetClosestTrendLocations () {
    io:println("--------------Calling getClosestTrendLocations----------------");
    string latitude = "34";
    string longitude = "67";
    Location[] tweetResponse = check twitterClient -> getClosestTrendLocations (latitude, longitude);
    test:assertNotEquals(tweetResponse, null, msg = "Failed to call getClosestTrendLocations()");
}

@test:Config
function testGetTopTrendsByPlace () {
    io:println("--------------Calling getTopTrendsByPlace----------------");
    string locationId = "23424922";
    Trends[] tweetResponse = check twitterClient -> getTopTrendsByPlace (locationId);
    test:assertNotEquals(tweetResponse, null, msg = "Failed to call getTopTrendsByPlace()");
}

