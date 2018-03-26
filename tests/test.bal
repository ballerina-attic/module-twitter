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

import ballerina/io;
import twitter;
import ballerina/net.http;
import ballerina/mime;

public function main (string[] args) {
    twitter:TwitterConnector twitter = {};
    http:HttpConnectorError e = {};
    twitter.init(args[1], args[2], args[3], args[4]);

    if (args[0] == "tweet") {
        io:println("--------------Calling tweet----------------");
        string status = args[5];
        var tweetResponse = twitter.tweet(status);
        twitter:Status twitterStatus = {};

        match tweetResponse {
            twitter:Status response => {
                twitterStatus = response;
                io:println("Tweet id : " + twitterStatus.id);
                io:println("Tweet message : " + twitterStatus.text);
                io:println("Tweet language : " + twitterStatus.lang);
            }
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "retweet") {
        io:println("--------------Calling retweet----------------");
        string id = args[5];
        var tweetResponse = twitter.retweet (id);
        twitter:Status twitterStatus = {};

        match tweetResponse {
            twitter:Status response => {
                twitterStatus = response;
                io:println("Tweet id : " + twitterStatus.id);
                io:println("Tweet message : " + twitterStatus.text);
                io:println("Tweet language : " + twitterStatus.lang);
            }
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "unretweet") {
        io:println("--------------Calling unretweet----------------");
        string id = args[5];
        var tweetResponse = twitter.unretweet (id);
        twitter:Status twitterStatus = {};

        match tweetResponse {
            twitter:Status response => {
                twitterStatus = response;
                io:println("Tweet id : " + twitterStatus.id);
                io:println("Tweet message : " + twitterStatus.text);
                io:println("Tweet language : " + twitterStatus.lang);
            }
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "search") {
        io:println("--------------Calling search----------------");
        string queryStr = args[5];
        var tweetResponse = twitter.search (queryStr);

        match tweetResponse {
            http:Response response => {
                var jsonPayload = response.getJsonPayload();
                match jsonPayload {
                    json j => io:println(j);
                    mime:EntityError err => io:println(err);
                }
            }
            http:HttpConnectorError err => io:println(err);
        }
    } else if (args[0] == "showStatus") {
        io:println("--------------Calling showStatus----------------");
        string id = args[5];
        var tweetResponse = twitter.showStatus (id);
        twitter:Status twitterStatus = {};

        match tweetResponse {
            twitter:Status response => {
                twitterStatus = response;
                io:println("Tweet id : " + twitterStatus.id);
                io:println("Tweet message : " + twitterStatus.text);
                io:println("Tweet language : " + twitterStatus.lang);
            }
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "destroyStatus") {
        io:println("--------------Calling destroyStatus----------------");
        string id = args[5];
        var tweetResponse = twitter.destroyStatus (id);
        twitter:Status twitterStatus = {};

        match tweetResponse {
            twitter:Status response => {
                twitterStatus = response;
                io:println("Tweet id : " + twitterStatus.id);
                io:println("Tweet message : " + twitterStatus.text);
                io:println("Tweet language : " + twitterStatus.lang);
            }
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "getClosestTrendLocations") {
        io:println("--------------Calling getClosestTrendLocations----------------");
        string latitude = args[5];
        string longitude = args[6];
        var tweetResponse = twitter.getClosestTrendLocations (latitude, longitude);

        match tweetResponse {
            http:Response response => {
                var jsonPayload = response.getJsonPayload();
                match jsonPayload {
                    json j => io:println(j);
                    mime:EntityError err => io:println(err);
                }
            }
            http:HttpConnectorError err => io:println(err);
        }
    } else if (args[0] == "getTopTrendsByPlace") {
        io:println("--------------Calling getTopTrendsByPlace----------------");
        string locationId = args[5];
        var tweetResponse = twitter.getTopTrendsByPlace (locationId);

        match tweetResponse {
            http:Response response => {
                var jsonPayload = response.getJsonPayload();
                match jsonPayload {
                    json j => io:println(j);
                    mime:EntityError err => io:println(err);
                }
            }
            http:HttpConnectorError err => io:println(err);
        }
    }
}
