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

string testClientId = config:getAsString("CLIENT_ID");
string testClientSecret = config:getAsString("CLIENT_SECRET");
string testAccessToken = config:getAsString("ACCESS_TOKEN");
string testAccessTokenSecret = config:getAsString("ACCESS_TOKEN_SECRET");

int tweetId = 0;
string userId = "4269258922";
string currentTimeStamp = "";
int[] mediaIds = [1111489293829226501, 1111489391845953536];
int sinceId = 1108616819688927232;
int maxId = 1110365503862833154;

TwitterConfiguration twitterConfig = {
    clientId: testClientId,
    clientSecret: testClientSecret,
    accessToken: testAccessToken,
    accessTokenSecret: testAccessTokenSecret
};

MediaParams mediaParams = {
    // Here, you can pass media as attachment_url or media_ids
    media: "https://twitter.com/andypiper/status/903615884664725505",
    //media: mediaIds,
    possiblySensitive: false
};

LocationParams locationParams = {
    // Here, you can pass placeInfo as (latitude, longitude) or place_id.
    placeInfo: (37.7821120598956, 122.400612831116),
    //placeInfo: "df51dec6f4ee2b2c",
    displayCoordinates: true
};

StatusReplyParams replyParams = {
    inReplyToStatusId: tweetId,
    autoPopulateReplyMetadata: true,
    excludeReplyUserIds: userId
};

@test:Config
function testTweet() {
    io:println("--------------Calling tweet----------------");

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        time:Time time = time:currentTime();
        int currentTimeMills = time.time;
        currentTimeStamp = io:sprintf("%s", currentTimeMills / 1000);
        string status = "Sample Tweet " + currentTimeStamp;
        var tweetResponse = twitterClient->tweet(status, trimUser = false, enableDmcommands = false,
            failDmcommands = true, mediaParams = mediaParams, locationParams = locationParams);

        if (tweetResponse is Tweet) {
            tweetId = tweetResponse.id;
            io:println("Tweet: ", tweetResponse);
            test:assertTrue(tweetResponse.text.contains(status), msg = "Failed to call tweet()");
        } else {
            test:assertFail(msg = <string>tweetResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}

@test:Config {
    dependsOn: ["testTweet"]
}
function testReplyToTweet() {
    io:println("--------------Calling replyToTweet----------------");

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        string status = "Sample Tweet Reply " + currentTimeStamp;

        var replyToTweetResponse = twitterClient->replyToTweet(status, replyParams, trimUser = false,
            enableDmcommands = false, failDmcommands = true, mediaParams = mediaParams,
            locationParams = locationParams);

        if (replyToTweetResponse is Tweet) {
            io:println("Tweet: ", replyToTweetResponse);
            test:assertTrue(replyToTweetResponse.text.contains(status), msg = "Failed to call replyToTweet()");
        } else {
            test:assertFail(msg = <string>replyToTweetResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}

@test:Config {
    dependsOn: ["testTweet"]
}
function testRetweet() {
    io:println("--------------Calling retweet----------------");

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        var retweetResponse = twitterClient->retweet(tweetId, trimUser = false);

        if (retweetResponse is Tweet) {
            io:println("Retweet: ", retweetResponse);
            test:assertTrue(retweetResponse.retweeted, msg = "Failed to call retweet()");
        } else {
            test:assertFail(msg = <string>retweetResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}

@test:Config {
    dependsOn: ["testTweet"]
}
function testCreateFavoriteTweet() {
    io:println("--------------Calling createFavoriteTweet----------------");

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        var favoriteTweetResponse = twitterClient->createFavoriteTweet(tweetId, includeEntities = false);

        if (favoriteTweetResponse is Tweet) {
            io:println("FavoriteTweet: ", favoriteTweetResponse);
            test:assertTrue(<boolean>favoriteTweetResponse.favorited, msg = "Failed to call createFavoriteTweet()");
        } else {
            test:assertFail(msg = <string>favoriteTweetResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}

@test:Config
function testSearch() {
    io:println("--------------Calling search----------------");

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        string queryStr = "twitter";
        var searchResponse = twitterClient->search(queryStr, count = 20, lang = "eu", includeEntities = false,
            sinceId = sinceId, maxId = 1108617435769241602, locale = "ja",
            geocode = "37.781157, -122.398720, '1mi'", until = "2019-03-19");

        if (searchResponse is Search) {
            io:println("Search Result: ", searchResponse);
            test:assertTrue(searchResponse.search_metadata.query.contains(queryStr), msg = "Failed to call search()");
        } else {
            test:assertFail(msg = <string>searchResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}

@test:Config
function testGetHomeTimelineTweets() {
    io:println("--------------Calling getHomeTimelineTweets----------------");

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        var homeTimelineResponse = twitterClient->getHomeTimelineTweets(count = 20, sinceId = sinceId,
            maxId = maxId, trimUser = false, excludeReplies = false, includeEntities = false);

        if (homeTimelineResponse is Tweet[]) {
            io:println("HomeTimelineTweets: ", homeTimelineResponse);
            test:assertTrue(homeTimelineResponse.length() > 0, msg = "Failed to call getHomeTimelineTweets()");
        } else {
            test:assertFail(msg = <string>homeTimelineResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}

@test:Config
function testGetTweetMentions() {
    io:println("--------------Calling getTweetMentions----------------");

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        var tweetMentionsResponse = twitterClient->getTweetMentions(count = 5,
            trimUser = false, includeEntities = false);

        if (tweetMentionsResponse is Tweet[]) {
            io:println("Tweet Mentions: ", tweetMentionsResponse);
            test:assertTrue(tweetMentionsResponse.length() > 0, msg = "Failed to call getTweetMentions()");
        } else {
            test:assertFail(msg = <string>tweetMentionsResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}

@test:Config
function testGetFollowers() {
    io:println("--------------Calling getFollowers----------------");

    TwitterUserClient|error twitterUserClientWithConfig = new(twitterConfig);
    if (twitterUserClientWithConfig is TwitterUserClient) {
        var followersResponseWithConfig = twitterUserClientWithConfig->getFollowers(screenName = "WSO2",
            cursor = -1, count = 10, skipStatus = true, includeUserEntities = false);

        int followersCount = 0;
        if (followersResponseWithConfig is Followers) {
            TruncatedUser[]|User[] users = followersResponseWithConfig.users;
            if (users is User[]) {
                User[]|error userList = User[].convert(users);
                if (userList is User[]) {
                    followersCount = userList.length();
                }
            } else {
                TruncatedUser[]|error userList = TruncatedUser[].convert(users);
                if (userList is TruncatedUser[]) {
                    followersCount = userList.length();
                }
            }
            io:println("Followers Count: ", followersCount);
            test:assertTrue(followersCount > 0, msg = "Failed to call getFollowers()");
        } else {
            test:assertFail(msg = <string>followersResponseWithConfig.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterUserClientWithConfig.detail().message);
    }

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        TwitterUserClient twitterUserClient = twitterClient.getUserClient();
        var followersResponse = twitterUserClient->getFollowers(screenName = "WSO2", cursor = -1, count = 10,
            skipStatus = true, includeUserEntities = false);
        
        int followersCount = 0;
        if (followersResponse is Followers) {
            TruncatedUser[]|User[] users = followersResponse.users;
            if (users is User[]) {
                User[]|error userList = User[].convert(users);
                if (userList is User[]) {
                    followersCount = userList.length();
                }
            } else {
                TruncatedUser[]|error userList = TruncatedUser[].convert(users);
                if (userList is TruncatedUser[]) {
                    followersCount = userList.length();
                }
            }
            io:println("Followers Count: ", followersCount);
            test:assertTrue(followersCount > 0, msg = "Failed to call getFollowers()");
        } else {
            test:assertFail(msg = <string>followersResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}

@test:Config
function testGetClosestTrendLocations() {
    io:println("--------------Calling getClosestTrendLocations----------------");

    float latitude = 34.0;
    float longitude = 67.0;
    TwitterTrendsClient|error twitterTrendsClientWithConfig = new(twitterConfig);
    if (twitterTrendsClientWithConfig is TwitterTrendsClient) {
        var locationResponseWithConfig = twitterTrendsClientWithConfig->getClosestTrendLocations(latitude, longitude);
        if (locationResponseWithConfig is Location[]) {
            io:println("Locations: ", locationResponseWithConfig);
            test:assertTrue(locationResponseWithConfig.length() > 0, msg = "Failed to call getClosestTrendLocations()");
        } else {
            test:assertFail(msg = <string>locationResponseWithConfig.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterTrendsClientWithConfig.detail().message);
    }

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        TwitterTrendsClient twitterTrendsClient = twitterClient.getTrendsClient();
        var locationResponse = twitterTrendsClient->getClosestTrendLocations(latitude, longitude);
        if (locationResponse is Location[]) {
            io:println("Locations: ", locationResponse);
            test:assertTrue(locationResponse.length() > 0, msg = "Failed to call getClosestTrendLocations()");
        } else {
            test:assertFail(msg = <string>locationResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}

@test:Config
function testGetTrendsByPlace() {
    io:println("--------------Calling getTopTrendsByPlace----------------");

    int locationId = 23424922;
    TwitterTrendsClient|error twitterTrendsClientWithConfig = new(twitterConfig);
    if (twitterTrendsClientWithConfig is TwitterTrendsClient) {
        var trendsResponseWithConfig = twitterTrendsClientWithConfig->getTrendsByPlace(locationId);
        if (trendsResponseWithConfig is TrendsList[]) {
            io:println("Trends: ", trendsResponseWithConfig);
            test:assertTrue(trendsResponseWithConfig.length() > 0, msg = "Failed to call getTopTrendsByPlace()");
        } else {
            test:assertFail(msg = <string>trendsResponseWithConfig.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterTrendsClientWithConfig.detail().message);
    }

    TwitterClient|error twitterClient = new(twitterConfig);
    if (twitterClient is TwitterClient) {
        TwitterTrendsClient twitterTrendsClient = twitterClient.getTrendsClient();
        var trendsResponse = twitterTrendsClient->getTrendsByPlace(locationId);
        if (trendsResponse is TrendsList[]) {
            io:println("Trends: ", trendsResponse);
            test:assertTrue(trendsResponse.length() > 0, msg = "Failed to call getTopTrendsByPlace()");
        } else {
            test:assertFail(msg = <string>trendsResponse.detail().message);
        }
    } else {
        test:assertFail(msg = <string>twitterClient.detail().message);
    }
}
