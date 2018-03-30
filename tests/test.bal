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

    endpoint twitter:TwitterEndpoint twitterEP {
        clientId:args[1],
        clientSecret:args[2],
        accessToken:args[3],
        accessTokenSecret:args[4],
        clientConfig:{}
    };

    twitter:TwitterConnector twitter = {};
    http:HttpConnectorError e = {};

    if (args[0] == "tweet") {
        io:println("--------------Calling tweet----------------");
        string status = args[5];
        var tweetResponse = twitterEP -> tweet(status);

        match tweetResponse {
            twitter:Status response => io:println(response);
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "retweet") {
        io:println("--------------Calling retweet----------------");
        string id = args[5];
        var tweetResponse = twitterEP -> retweet (id);

        match tweetResponse {
            twitter:Status response => io:println(response);
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "unretweet") {
        io:println("--------------Calling unretweet----------------");
        string id = args[5];
        var tweetResponse = twitterEP -> unretweet (id);

        match tweetResponse {
            twitter:Status response => io:println(response);
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "search") {
        io:println("--------------Calling search----------------");
        string queryStr = args[5];
        var tweetResponse = twitterEP -> search (queryStr);

        match tweetResponse {
            twitter:Status[] response => io:println(response);
            twitter:TwitterError err => io:println(err);
        }
    } else if (args[0] == "showStatus") {
        io:println("--------------Calling showStatus----------------");
        string id = args[5];
        var tweetResponse = twitterEP -> showStatus (id);

        match tweetResponse {
            twitter:Status response => io:println(response);
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "destroyStatus") {
        io:println("--------------Calling destroyStatus----------------");
        string id = args[5];
        var tweetResponse = twitterEP -> destroyStatus (id);

        match tweetResponse {
            twitter:Status response => io:println(response);
            twitter:TwitterError err => io:println("Error message : " + err.errorMessage);
        }
    } else if (args[0] == "getClosestTrendLocations") {
        io:println("--------------Calling getClosestTrendLocations----------------");
        string latitude = args[5];
        string longitude = args[6];
        var tweetResponse = twitterEP -> getClosestTrendLocations (latitude, longitude);

        match tweetResponse {
            twitter:Location[] response => io:println(response);
            twitter:TwitterError err => io:println(err);
        }
    } else if (args[0] == "getTopTrendsByPlace") {
        io:println("--------------Calling getTopTrendsByPlace----------------");
        string locationId = args[5];
        var tweetResponse = twitterEP -> getTopTrendsByPlace (locationId);

        match tweetResponse {
            twitter:Trends [] response => io:println(response);
            twitter:TwitterError err => io:println(err);
        }
    }
}
