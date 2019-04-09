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
import ballerina/io;

string clientIdStr = "";
string clientSecretStr = "";
string accessTokenStr = "";
string accessTokenSecretStr = "";

# Twitter Client object.
#
# + twitterClient - HTTP Client.
# + userClient - Twitter user client.
# + trendsClient - Twitter trends client.
public type TwitterClient client object {

    http:Client httpClient;
    TwitterClient twitterClient;
    TwitterUserClient userClient;
    TwitterTrendsClient trendsClient;

    public function __init(TwitterConfiguration twitterConfig) {
        self.httpClient = new(TWITTER_API_URL, config = twitterConfig.clientConfig);
        self.userClient = new(self.twitterClient);
        self.trendsClient = new(self.twitterClient);
        accessTokenStr = twitterConfig.accessToken;
        accessTokenSecretStr = twitterConfig.accessTokenSecret;
        clientIdStr = twitterConfig.clientId;
        clientSecretStr = twitterConfig.clientSecret;
    }

    # Updates the authenticating user's current status, also known as Tweeting.
    #
    # + status - The text of the status update.
    # + cardUri - Associate an ads card with the Tweet.
    # + trimUser - When set to either true, the response will include a user object including only the
    #              author's ID. Omit this parameter to receive the complete user object.
    # + enableDmcommands - When set to true, enables shortcode commands for sending Direct Messages as part of the
    #                      status text to send a Direct Message to a user.
    # + failDmcommands - When set to true, causes any status text that starts with shortcode commands to return an
    #                    API error. When set to false, allows shortcode commands to be sent in the status text and
    #                    acted on by the API.
    # + mediaParams - List of params that is needed to attach medias with the Tweet.
    # + locationParams - List of params that is needed to attach location details with the Tweet.
    # + return - Returns the Tweet object when successful, else returns an error.
    public remote function tweet(string status, string? cardUri = (), boolean? trimUser = (),
                                 boolean? enableDmcommands = (), boolean? failDmcommands = (),
                                 MediaParams? mediaParams = (), LocationParams? locationParams = ())
                               returns Tweet|error;

    # Updates the reply to authenticating user's current status.
    #
    # + status - The text of the status update.
    # + replyParams - List of params that is needed to add the reply to an existing Tweet.
    # + cardUri - Associate an ads card with the Tweet.
    # + trimUser - When set to either true, the response will include a user object including only the
    #              author's ID. Omit this parameter to receive the complete user object.
    # + enableDmcommands - When set to true, enables shortcode commands for sending Direct Messages as part of the
    #                      status text to send a Direct Message to a user.
    # + failDmcommands - When set to true, causes any status text that starts with shortcode commands to return an
    #                    API error. When set to false, allows shortcode commands to be sent in the status text and
    #                    acted on by the API.
    # + mediaParams - List of params that is needed to attach medias with the Tweet.
    # + locationParams - List of params that is needed to attach location details with the Tweet.
    # + return - Returns the Tweet object when successful, else returns an error.
    public remote function replyToTweet(string status, StatusReplyParams replyParams, string? cardUri = (),
                                        boolean? trimUser = (), boolean? enableDmcommands = (),
                                        boolean? failDmcommands = (), MediaParams? mediaParams = (),
                                        LocationParams? locationParams = ()) returns Tweet|error;

    # Retweet a tweet. It will return the original Tweet with Retweet details embedded.
    #
    # + tweetId - The numerical ID of the desired status.
    # + trimUser - When set to true, each tweet returned in a timeline will include a user object including only the
    #              status authors numerical ID. Omit this parameter to receive the complete user object.
    # + return - Returns the Tweet object when successful, else returns an error.
    public remote function retweet(int tweetId, boolean? trimUser = ()) returns Tweet|error;

    # Favorites (likes) the Tweet specified in the ID parameter as the authenticating user.
    #
    # + tweetId - The numerical ID of the Tweet to like.
    # + includeEntities - The entities node will be omitted when set to false.
    # + return - Returns the favorite Tweet object when successful, else returns an error.
    public remote function createFavoriteTweet(int tweetId, boolean? includeEntities = ()) returns Tweet|error;

    # Search a collection of relevant Tweets matching a specified query.
    #
    # + query - Query string to retrieve the related tweets.
    # + count - The number of tweets to return per page, up to a maximum of 100.
    # + lang - Restricts tweets to the given language, given by an ISO 639-1 code.
    # + includeEntities - The entities node will not be included when set to false.
    # + sinceId - Returns results with an ID greater than (that is, more recent than) the specified ID.
    # + maxId - Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # + locale - Specify the language of the query you are sending.
    # + geocode - Returns tweets by users located within a given radius of the given latitude/longitude.
    # + until - Returns tweets created before the given date. Date should be formatted as YYYY-MM-DD.
    # + resultType - Specifies what type of search results you would prefer to receive.
    # + return - Returns the Search object when successful, else returns an error
    public remote function search(string query, int? count = (), string? lang = (), boolean? includeEntities = (),
                                  int? sinceId = (), int? maxId = (), string? locale = (), string? geocode = (),
                                  string? until = (), SearchResultType? resultType = ()) returns Search|error;

    # Returns a collection of the most recent Tweets and Retweets posted by the authenticating user and
    # the users they follow.
    #
    # + count - Specifies the number of records to retrieve.
    # + sinceId - Returns results with an ID greater than (that is, more recent than) the specified ID.
    # + maxId - Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # + trimUser - When set to true, each Tweet returned in a timeline will include a user object including only the
    #              status authors numerical ID. Omit this parameter to receive the complete user object.
    # + excludeReplies - This parameter will prevent replies from appearing in the returned timeline.
    # + includeEntities - The entities node will not be included when set to false.
    # + return - Returns a collection of Tweet object when successful, else returns an error.
    public remote function getHomeTimelineTweets(int? count = (), int? sinceId = (), int? maxId = (),
                                                 boolean? trimUser = (), boolean? excludeReplies = (),
                                                 boolean? includeEntities = ()) returns Tweet[]|error;

    # Returns the 20 most recent mentions (Tweets containing a users's @screen_name) for the authenticating user.
    # The timeline returned is the equivalent of the one seen when you view your mentions on twitter.com.
    #
    # + count - Specifies the number of Tweets to try and retrieve, up to a maximum of 200.
    # + sinceId - Returns results with an ID greater than (that is, more recent than) the specified ID.
    # + maxId - Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # + trimUser - When set to true, each tweet returned in a timeline will include a user object including only
    #              the status authors numerical ID. Omit this parameter to receive the complete user object.
    # + includeEntities - The entities node will not be included when set to false.
    # + return - Returns a collection of Tweet object when successful, else returns an error.
    public remote function getTweetMentions(int? count = (), int? sinceId = (), int? maxId = (), boolean? trimUser = (),
                                            boolean? includeEntities = ()) returns Tweet[]|error;

    # Get the sub-connector of user to invoke user related functions.
    #
    # + return - Returns TwitterUserClient object.
    public function getUserClient() returns TwitterUserClient {
        return self.userClient;
    }

    # Get the sub-connector of Trends to invoke Trend related functions.
    #
    # + return - Returns TwitterTrendsClient object.
    public function getTrendsClient() returns TwitterTrendsClient {
        return self.trendsClient;
    }

    public function getHttpClient() returns http:Client {
        return self.httpClient;
    }
};

# Twitter User Client object.
#
# + httpClient - HTTP Client.
public type TwitterUserClient client object {
    http:Client httpClient;

    public function __init(TwitterClient|TwitterConfiguration config) {
        if (config is TwitterClient) {
            self.httpClient = config.getHttpClient();
        } else {
            self.httpClient = new(TWITTER_API_URL, config = config.clientConfig);
            accessTokenStr = config.accessToken;
            accessTokenSecretStr = config.accessTokenSecret;
            clientIdStr = config.clientId;
            clientSecretStr = config.clientSecret;
        }
    }

    # Returns a cursored collection of user objects for users following the specified user.
    #
    # + userId - The ID of the user for whom to return results.
    # + screenName - The screen name of the user for whom to return results.
    # + cursor - Causes the results to be broken into pages. If no cursor is provided, a value of -1 will be assumed,
    #            which is the first "page."
    # + count - The number of users to return per page, up to a maximum of 200.
    # + skipStatus - When set to true, statuses will not be included in the returned user objects.
    # + includeUserEntities - The user object entities node will not be included when set to false.
    # + return - Returns Followers object when successful, else returns an error.
    public remote function getFollowers(int? userId = (), string? screenName = (), int? cursor = (), int? count = (),
                                        boolean? skipStatus = (), boolean? includeUserEntities = ())
                               returns Followers|error;
};

# Twitter Trends Client object.
#
# + httpClient - HTTP Client.
public type TwitterTrendsClient client object {
    http:Client httpClient;

    public function __init(TwitterClient|TwitterConfiguration twitterClient) {
        if (twitterClient is TwitterClient) {
            self.httpClient = twitterClient.getHttpClient();
        } else {
            self.httpClient = new(TWITTER_API_URL, config = twitterClient.clientConfig);
            accessTokenStr = twitterClient.accessToken;
            accessTokenSecretStr = twitterClient.accessTokenSecret;
            clientIdStr = twitterClient.clientId;
            clientSecretStr = twitterClient.clientSecret;
        }
    }

    # Returns the top trending topics for a specific WOEID, if trending information is available for it.
    #
    # + locationId - The ID of the location to return trending information for.
    # + exclude - Setting this equal to hashtags will remove all hashtags from the trends list.
    # + return - Returns a collection of TrendsList object when successful, else returns an error.
    public remote function getTrendsByPlace(int locationId, string? exclude = ()) returns TrendsList[]|error;

    # Returns the locations that Twitter has trending topic information for, closest to a specified location.
    #
    # + latitude - Latitude of the location.
    # + longitude - Longitude of the location.
    # + return - Returns a collection of Location object when successful, else returns an error.
    public remote function getClosestTrendLocations(float latitude, float longitude) returns Location[]|error;
};

public remote function TwitterClient.tweet(string status, string? cardUri = (), boolean? trimUser = (),
                                           boolean? enableDmcommands = (), boolean? failDmcommands = (),
                                           MediaParams? mediaParams = (), LocationParams? locationParams = ())
                                         returns Tweet|error {
    http:Client httpClient = self.httpClient;
var cc= verifyCredentials(httpClient);
    return updateStatus(httpClient, status, cardUri = cardUri, trimUser = trimUser, enableDmcommands = enableDmcommands,
        failDmcommands = failDmcommands, mediaParams = mediaParams, locationParams = locationParams);
}

public remote function TwitterClient.replyToTweet(string status, StatusReplyParams replyParams, string? cardUri = (),
                                                  boolean? trimUser = (), boolean? enableDmcommands = (),
                                                  boolean? failDmcommands = (), MediaParams? mediaParams = (),
                                                  LocationParams? locationParams = ()) returns Tweet|error {
    http:Client httpClient = self.httpClient;
    return updateStatus(httpClient, status, replyParams = replyParams, cardUri = cardUri, trimUser = trimUser,
        enableDmcommands = enableDmcommands, failDmcommands = failDmcommands, mediaParams = mediaParams,
        locationParams = locationParams);
}

public remote function TwitterClient.retweet(int tweetId, boolean? trimUser = ()) returns Tweet|error {
    http:Client httpClient = self.httpClient;
    map<anydata> parameters = {};
    http:Request request = new;
    string tweetPath = string `${RETWEET_ENDPOINT}${tweetId}${JSON}`;
    string urlParams = "";

    boolean trimUserValue = trimUser is boolean ? trimUser : false;
    string encodedTrimUserValue = check http:encode(string.convert(trimUserValue), UTF_8);
    urlParams = string `${urlParams}trim_user=${encodedTrimUserValue}`;
    parameters["trim_user"] = encodedTrimUserValue;

    var requestHeaders = constructRequestHeaders(request, POST, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, parameters);
    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        tweetPath = string `${tweetPath}?${urlParams}`;

        var httpResponse = httpClient->post(tweetPath, request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    Tweet|error retweetResponse = Tweet.convert(jsonPayload);
                    if (retweetResponse is Tweet) {
                        return retweetResponse.freeze();
                    } else {
                        error err = error(CONVERSION_ERROR_CODE, { ^"cause": retweetResponse,
                            message: "Error occurred while doing json conversion" });
                        return err;
                    }
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
}

public remote function TwitterClient.createFavoriteTweet(int tweetId,
                                                         boolean? includeEntities = ()) returns Tweet|error {
    http:Client httpClient = self.httpClient;
    map<anydata> parameters = {};
    http:Request request = new;
    string tweetPath = FAVORITE_ENDPOINT;

    string encodedTweetId = check http:encode(string.convert(tweetId), UTF_8);
    string urlParams = string `id=${encodedTweetId}`;
    parameters["id"] = encodedTweetId;

    if (includeEntities is boolean) {
        string encodedIncludeEntities = check http:encode(string.convert(includeEntities), UTF_8);
        parameters["include_entities"] = encodedIncludeEntities;
        urlParams = string `${urlParams}&include_entities=${encodedIncludeEntities}`;
    }

    var requestHeaders = constructRequestHeaders(request, POST, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, parameters);
    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        tweetPath = string `${tweetPath}?${urlParams}`;

        var httpResponse = httpClient->post(tweetPath, request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    Tweet|error favoriteTweetResponse = Tweet.convert(jsonPayload);
                    if (favoriteTweetResponse is Tweet) {
                        return favoriteTweetResponse.freeze();
                    } else {
                        error err = error(CONVERSION_ERROR_CODE, { ^"cause": favoriteTweetResponse,
                            message: "Error occurred while doing json conversion" });
                        return err;
                    }
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
}

public remote function TwitterClient.search(@sensitive string query, int? count = (), string? lang = (),
                                     boolean? includeEntities = (), int? sinceId = (), int? maxId = (),
                                     string? locale = (), string? geocode = (), string? until = (),
                                     SearchResultType? resultType = ()) returns Search|error {
    http:Client httpClient = self.httpClient;
    map<anydata> parameters = {};
    string tweetPath = SEARCH_ENDPOINT;

    string encodedQuery = check http:encode(query, UTF_8);
    string urlParams = string `q=${encodedQuery}`;
    parameters["q"] = encodedQuery;

    if (count is int) {
        string encodedCount = check http:encode(string.convert(count), UTF_8);
        parameters["count"] = encodedCount;
        urlParams = string `${urlParams}&count=${encodedCount}`;
    }
    if (lang is string) {
        string encodedLang = check http:encode(lang, UTF_8);
        parameters["lang"] = encodedLang;
        urlParams = string `${urlParams}&lang=${encodedLang}`;
    }
    if (includeEntities is boolean) {
        string encodedIncludeEntities = check http:encode(string.convert(includeEntities), UTF_8);
        parameters["include_entities"] = encodedIncludeEntities;
        urlParams = string `${urlParams}&include_entities=${encodedIncludeEntities}`;
    }
    if (sinceId is int) {
        string encodedSinceId = check http:encode(string.convert(sinceId), UTF_8);
        parameters["since_id"] = encodedSinceId;
        urlParams = string `${urlParams}&since_id=${encodedSinceId}`;
    }
    if (maxId is int) {
        string encodedMaxId = check http:encode(string.convert(maxId), UTF_8);
        parameters["max_id"] = encodedMaxId;
        urlParams = string `${urlParams}&max_id=${encodedMaxId}`;
    }
    if (locale is string) {
        string encodedLocale = check http:encode(locale, UTF_8);
        parameters["locale"] = encodedLocale;
        urlParams = string `${urlParams}&locale=${encodedLocale}`;
    }
    if (geocode is string) {
        string encodedGeocode = check http:encode(geocode, UTF_8);
        parameters["geocode"] = encodedGeocode;
        urlParams = string `${urlParams}&geocode=${encodedGeocode}`;
    }
    if (until is string) {
        string encodedUntil = check http:encode(until, UTF_8);
        parameters["until"] = encodedUntil;
        urlParams = string `${urlParams}&until=${encodedUntil}`;
    }
    if (resultType is SearchResultType) {
        parameters["result_type"] = resultType;
        urlParams = string `${urlParams}&result_type=${<string>resultType}`;
    }

    http:Request request = new;
    var requestHeaders = constructRequestHeaders(request, GET, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, parameters);
    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        tweetPath = string `${tweetPath}?${urlParams}`;

        var httpResponse = httpClient->get(tweetPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    Search|error searchResponse = Search.convert(jsonPayload);
                    if (searchResponse is Search) {
                        return searchResponse.freeze();
                    } else {
                        error err = error(CONVERSION_ERROR_CODE, { ^"cause": searchResponse,
                            message: "Error occurred while doing json conversion" });
                        return err;
                    }
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
}

public remote function TwitterClient.getHomeTimelineTweets(int? count = (), int? sinceId = (), int? maxId = (),
                                                    boolean? trimUser = (), boolean? excludeReplies = (),
                                                    boolean? includeEntities = ()) returns Tweet[]|error {
    http:Client httpClient = self.httpClient;
    map<anydata> parameters = {};
    http:Request request = new;
    string tweetPath = HOME_TIMELINE_ENDPOINT;
    string urlParams = "";

    if (count is int) {
        string encodedCount = check http:encode(string.convert(count), UTF_8);
        parameters["count"] = encodedCount;
        urlParams = string `${urlParams}&count=${encodedCount}`;
    }
    if (sinceId is int ) {
        string encodedSinceId = check http:encode(string.convert(sinceId), UTF_8);
        parameters["since_id"] = encodedSinceId;
        urlParams = string `${urlParams}&since_id=${encodedSinceId}`;
    }
    if (maxId is int ) {
        string encodedMaxId = check http:encode(string.convert(maxId), UTF_8);
        parameters["max_id"] = encodedMaxId;
        urlParams = string `${urlParams}&max_id=${encodedMaxId}`;
    }
    if (trimUser is boolean) {
        string encodedTrimUser = check http:encode(string.convert(trimUser), UTF_8);
        parameters["trim_user"] = encodedTrimUser;
        urlParams = string `${urlParams}&trim_user=${encodedTrimUser}`;

    }
    if (excludeReplies is boolean) {
        string encodedExcludeReplies = check http:encode(string.convert(excludeReplies), UTF_8);
        parameters["exclude_replies"] = encodedExcludeReplies;
        urlParams = string `${urlParams}&exclude_replies=${encodedExcludeReplies}`;

    }
    if (includeEntities is boolean) {
        string encodedIncludeEntities = check http:encode(string.convert(includeEntities), UTF_8);
        parameters["include_entities"] = encodedIncludeEntities;
        urlParams = string `${urlParams}&include_entities=${encodedIncludeEntities}`;
    }

    var requestHeaders = constructRequestHeaders(request, GET, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, parameters);
    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        if (urlParams != "") {
            tweetPath = string `${tweetPath}?${urlParams.substring(1, urlParams.length())}`;
        }

        var httpResponse = httpClient->get(tweetPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    Tweet[]|error homeTimelineResponse = Tweet[].convert(jsonPayload);
                    if (homeTimelineResponse is Tweet[]) {
                        return homeTimelineResponse.freeze();
                    } else {
                        error err = error(CONVERSION_ERROR_CODE, { ^"cause": homeTimelineResponse,
                            message: "Error occurred while doing json conversion" });
                        return err;
                    }
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
}

public remote function TwitterClient.getTweetMentions(int? count = (), int? sinceId = (), int? maxId = (),
                                                      boolean? trimUser = (), boolean? includeEntities = ())
                                         returns Tweet[]|error {
    http:Client httpClient = self.httpClient;
    map<anydata> parameters = {};
    http:Request request = new;
    string tweetPath = MENTIONS_ENDPOINT;
    string urlParams = "";

    if (count is int) {
        string encodedCount = check http:encode(string.convert(count), UTF_8);
        parameters["count"] = encodedCount;
        urlParams = string `${urlParams}&count=${encodedCount}`;
    }
    if (sinceId is int) {
        string encodedSinceId = check http:encode(string.convert(sinceId), UTF_8);
        parameters["since_id"] = encodedSinceId;
        urlParams = string `${urlParams}&since_id=${encodedSinceId}`;
    }
    if (maxId is int) {
        string encodedMaxId = check http:encode(string.convert(maxId), UTF_8);
        parameters["max_id"] = encodedMaxId;
        urlParams = string `${urlParams}&max_id=${encodedMaxId}`;
    }
    if (trimUser is boolean) {
        string encodedTrimUser = check http:encode(string.convert(trimUser), UTF_8);
        parameters["trim_user"] = encodedTrimUser;
        urlParams = string `${urlParams}&trim_user=${encodedTrimUser}`;
    }
    if (includeEntities is boolean) {
        string encodedIncludeEntities = check http:encode(string.convert(includeEntities), UTF_8);
        parameters["include_entities"] = encodedIncludeEntities;
        urlParams = string `${urlParams}&include_entities=${encodedIncludeEntities}`;
    }

    var requestHeaders = constructRequestHeaders(request, GET, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, parameters);
    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        if (urlParams != "") {
            tweetPath = string `${tweetPath}?${urlParams.substring(1, urlParams.length())}`;
        }

        var httpResponse = httpClient->get(tweetPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    Tweet[]|error tweetMentionsResponse = Tweet[].convert(jsonPayload);
                    if (tweetMentionsResponse is Tweet[]) {
                        return tweetMentionsResponse.freeze();
                    } else {
                        error err = error(CONVERSION_ERROR_CODE, { ^"cause": tweetMentionsResponse,
                            message: "Error occurred while doing json conversion" });
                        return err;
                    }
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
}

public remote function TwitterUserClient.getFollowers(int? userId = (), string? screenName = (), int? cursor = (),
                                                      int? count = (), boolean? skipStatus = (),
                                                      boolean? includeUserEntities = ()) returns Followers|error {
    http:Client httpClient = self.httpClient;
    map<anydata> parameters = {};
    http:Request request = new;
    string tweetPath = FOLLOWERS_ENDPOINT;
    string urlParams = "";

    if (userId is int) {
        string encodedUserId = check http:encode(string.convert(userId), UTF_8);
        parameters["user_id"] = encodedUserId;
        urlParams = string `${urlParams}&user_id=${encodedUserId}`;
    }
    if (screenName is string) {
        string encodedScreenName = check http:encode(screenName, UTF_8);
        parameters["screen_name"] = encodedScreenName;
        urlParams = string `${urlParams}&screen_name=${encodedScreenName}`;
    }
    if (cursor is int) {
        string encodedCursor = check http:encode(string.convert(cursor), UTF_8);
        parameters["cursor"] = encodedCursor;
        urlParams = string `${urlParams}&cursor=${encodedCursor}`;
    }
    if (count is int) {
        string encodedCount = check http:encode(string.convert(count), UTF_8);
        parameters["count"] = encodedCount;
        urlParams = string `${urlParams}&count=${encodedCount}`;
    }

    boolean skipStatusValue = skipStatus is boolean ? skipStatus : false;
    string encodedSkipStatus = check http:encode(string.convert(skipStatusValue), UTF_8);
    parameters["skip_status"] = encodedSkipStatus;
    urlParams = string `${urlParams}&skip_status=${encodedSkipStatus}`;

    boolean includeUserEntitiesValue = includeUserEntities is boolean ? includeUserEntities : true;
    string encodedIncludeUserEntities = check http:encode(string.convert(includeUserEntitiesValue), UTF_8);
    parameters["include_user_entities"] = encodedIncludeUserEntities;
    urlParams = string `${urlParams}&include_user_entities=${encodedIncludeUserEntities}`;

    var requestHeaders = constructRequestHeaders(request, GET, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, parameters);
    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        tweetPath = string `${tweetPath}?${urlParams.substring(1, urlParams.length())}`;

        var httpResponse = httpClient->get(tweetPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    Followers|error followersResponse = Followers.convert(jsonPayload);
                    if (followersResponse is Followers) {
                        return followersResponse.freeze();
                    } else {
                        error err = error(CONVERSION_ERROR_CODE, { ^"cause": followersResponse,
                            message: "Error occurred while doing json conversion" });
                        return err;
                    }
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
}

public remote function TwitterTrendsClient.getTrendsByPlace(int locationId,
                                                            string? exclude = ()) returns TrendsList[]|error {
    http:Client httpClient = self.httpClient;
    map<anydata> parameters = {};
    string tweetPath = TRENDS_PLACE_ENDPOINT;

    string encodedLocationId = check http:encode(string.convert(locationId), UTF_8);
    string urlParams = string `id=${encodedLocationId}`;
    parameters["id"] = encodedLocationId;

    if (exclude is string) {
        string encodedExclude = check http:encode(exclude, UTF_8);
        urlParams = string `${urlParams}&exclude=${encodedExclude}`;
        parameters["exclude"] = encodedExclude;
    }

    http:Request request = new;
    var requestHeaders = constructRequestHeaders(request, GET, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, parameters);
    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        tweetPath = string `${tweetPath}?${urlParams}`;

        var httpResponse = httpClient->get(tweetPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    TrendsList[]|error trendResponse = TrendsList[].convert(jsonPayload);
                    if (trendResponse is TrendsList[]) {
                        return trendResponse.freeze();
                    } else {
                        error err = error(CONVERSION_ERROR_CODE, { ^"cause": trendResponse,
                            message: "Error occurred while doing json conversion" });
                        return err;
                    }
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
}

public remote function TwitterTrendsClient.getClosestTrendLocations(float latitude,
                                                                    float longitude) returns Location[]|error {
    http:Client httpClient = self.httpClient;
    map<anydata> parameters = {};
    string tweetPath = TRENDS_ENDPOINT;

    string encodedLatitude = check http:encode(string.convert(latitude), UTF_8);
    string encodedLongitude = check http:encode(string.convert(longitude), UTF_8);
    parameters["lat"] = encodedLatitude;
    parameters["long"] = encodedLongitude;
    string urlParams = string `lat=${encodedLatitude}&long=${encodedLongitude}`;

    http:Request request = new;
    var requestHeaders = constructRequestHeaders(request, GET, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, parameters);

    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        tweetPath = string `${tweetPath}?${urlParams}`;

        var httpResponse = httpClient->get(tweetPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    Location[]|error locations = Location[].convert(jsonPayload);
                    if (locations is Location[]) {
                        return locations.freeze();
                    } else {
                        error err = error(CONVERSION_ERROR_CODE, { ^"cause": locations,
                            message: "Error occurred while doing json conversion" });
                        return err;
                    }
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
}

# Updates the authenticating user's current status, also known as Tweeting.
#
# + httpClient - HTTP client object.
# + status - The text of the status update.
# + replyParams - List of params that is needed to add the reply to an existing Tweet.
# + cardUri - Associate an ads card with the Tweet.
# + trimUser - When set to either true, the response will include a user object including only the
#              author's ID. Omit this parameter to receive the complete user object.
# + enableDmcommands - When set to true, enables shortcode commands for sending Direct Messages as part of the
#                      status text to send a Direct Message to a user.
# + failDmcommands - When set to true, causes any status text that starts with shortcode commands to return an
#                    API error. When set to false, allows shortcode commands to be sent in the status text and
#                    acted on by the API.
# + mediaParams - List of params that is needed to attach medias with the Tweet.
# + locationParams - List of params that is needed to attach location details with the Tweet.
# + return - Returns the Tweet object when successful, else returns an error.
function updateStatus(http:Client httpClient, string status, StatusReplyParams? replyParams = (),
                      string? cardUri = (), boolean? trimUser = (), boolean? enableDmcommands = (),
                      boolean? failDmcommands = (), MediaParams? mediaParams = (), LocationParams? locationParams = ())
             returns Tweet|error {

    map<anydata> parameters = {};
    http:Request request = new;
    string tweetPath = UPDATE_ENDPOINT;

    string encodedStatusValue = check http:encode(status, UTF_8);
    parameters["status"] = encodedStatusValue;
    string urlParams = string `status=${encodedStatusValue}`;

    if (cardUri is string) {
        string encodedCardUri = check http:encode(cardUri, UTF_8);
        parameters["card_uri"] = encodedCardUri;
        urlParams = string `${urlParams}&card_uri=${encodedCardUri}`;
    }

    boolean trimUserValue = trimUser is boolean ? trimUser : false;
    string encodedTrimUser = check http:encode(string.convert(trimUserValue), UTF_8);
    parameters["trim_user"] = encodedTrimUser;
    urlParams = string `${urlParams}&trim_user=${encodedTrimUser}`;

    boolean enableDmcommandsValue = enableDmcommands is boolean ? enableDmcommands : false;
    string encodedEnableDmcommands = check http:encode(string.convert(enableDmcommandsValue), UTF_8);
    parameters["enable_dmcommands"] = encodedEnableDmcommands;
    urlParams = string `${urlParams}&enable_dmcommands=${encodedEnableDmcommands}`;

    boolean failDmcommandsValue = failDmcommands is boolean ? failDmcommands : true;
    string encodedFailDmcommands = check http:encode(string.convert(failDmcommandsValue), UTF_8);
    parameters["fail_dmcommands"] = encodedFailDmcommands;
    urlParams = string `${urlParams}&fail_dmcommands=${encodedFailDmcommands}`;

    if (replyParams is StatusReplyParams) {
        string encodedReplyToStatusId = check http:encode(string.convert(<int>replyParams["inReplyToStatusId"]), UTF_8);
        parameters["in_reply_to_status_id"] = encodedReplyToStatusId;
        urlParams = string `${urlParams}&in_reply_to_status_id=${encodedReplyToStatusId}`;

        string? excludeReplyUserIds = replyParams["excludeReplyUserIds"];
        if (excludeReplyUserIds is string) {
            string encodedExcludeReplyUserIds = check http:encode(excludeReplyUserIds, UTF_8);
            parameters["exclude_reply_user_ids"] = encodedExcludeReplyUserIds;
            urlParams = string `${urlParams}&exclude_reply_user_ids=${encodedExcludeReplyUserIds}`;
        }
        boolean? autoPopulateReplyMetadata = replyParams["autoPopulateReplyMetadata"];
        boolean autoPopulateReplyMetadataValue = autoPopulateReplyMetadata is boolean ? autoPopulateReplyMetadata
                                                                                      : false;
        string encodedAutoPopulateReplyMetadata = check http:encode(
                                                            string.convert(autoPopulateReplyMetadataValue), UTF_8);
        parameters["auto_populate_reply_metadata"] = encodedAutoPopulateReplyMetadata;
        urlParams = string `${urlParams}&auto_populate_reply_metadata=${encodedAutoPopulateReplyMetadata}`;
    }

    if (mediaParams is MediaParams) {
        string|int[] media = <string|int[]>mediaParams["media"];
        if (media is string) {
            string encodedAttachment = check http:encode(media, UTF_8);
            parameters["attachment_url"] = encodedAttachment;
            urlParams = string `${urlParams}&attachment_url=${encodedAttachment}`;
        }
        if (media is int[]) {
            int index = 0;
            string mediaIds = "";
            foreach int mediaId in media {
                mediaIds = mediaIds + mediaId + ",";
                index = index + 1;
            }
            string encodedMediaIds = check http:encode(mediaIds.substring(0, mediaIds.length() - 1), UTF_8);
            parameters["media_ids"] = encodedMediaIds;
            urlParams = string `${urlParams}&media_ids=${encodedMediaIds}`;
        }

        boolean possiblySensitiveValue = mediaParams["possiblySensitive"] is boolean?
            <boolean>mediaParams["possiblySensitive"] : false;
        string encodedPossiblySensitive = check http:encode(string.convert(possiblySensitiveValue), UTF_8);
        parameters["possibly_sensitive"] = encodedPossiblySensitive;
        urlParams = string `${urlParams}&possibly_sensitive=${encodedPossiblySensitive}`;
    }

    if (locationParams is LocationParams) {
        (float, float)|string? place = locationParams["placeInfo"];
        if (place is (float, float)) {
            var (lat, long) = place;
            string encodedLat = check http:encode(string.convert(lat), UTF_8);
            string encodedLong = check http:encode(string.convert(long), UTF_8);
            parameters["lat"] = encodedLat;
            parameters["long"] = encodedLong;
            urlParams = string `${urlParams}&lat=${encodedLat}&long=${encodedLong}`;
        }
        if (place is string) {
            string encodedPlaceId = check http:encode(place, UTF_8);
            parameters["place_id"] = encodedPlaceId;
            urlParams = string `${urlParams}&place_id=${encodedPlaceId}`;
        }
        boolean? displayCoordinates = locationParams["displayCoordinates"];
        if (displayCoordinates is boolean) {
            string encodedDisplayCoordinates = check http:encode(string.convert(displayCoordinates), UTF_8);
            parameters["display_coordinates"] = encodedDisplayCoordinates;
            urlParams = string `${urlParams}&display_coordinates=${encodedDisplayCoordinates}`;
        }
    }

    var requestHeaders = constructRequestHeaders(request, POST, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, parameters);
    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        tweetPath = string `${tweetPath}?${urlParams}`;

        var httpResponse = httpClient->post(tweetPath, request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    Tweet|error tweetResponse = Tweet.convert(jsonPayload);
                    if (tweetResponse is Tweet) {
                        return tweetResponse.freeze();
                    } else {
                        error err = error(CONVERSION_ERROR_CODE, { ^"cause": tweetResponse,
                            message: "Error occurred while doing json conversion" });
                        return err;
                    }
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
}

public function verifyCredentials(http:Client httpClient) returns error? {
    http:Request request = new;
    string tweetPath = VERIFY_CREDENTIALS_ENDPOINT;

    var requestHeaders = constructRequestHeaders(request, GET, tweetPath, clientIdStr, clientSecretStr, accessTokenStr,
        accessTokenSecretStr, {});
    if (requestHeaders is error) {
        error err = error(ENCODING_ERROR_CODE, { ^"cause": requestHeaders,
            message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        //tweetPath = string `${tweetPath}?${urlParams}`;

        var httpResponse = httpClient->get(tweetPath, message = request);
        io:println("httpResponse---", httpResponse);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            io:println("jsonPayload---", jsonPayload);
            if (jsonPayload is json) {
                if (statusCode == 200) {
                    //Tweet|error tweetResponse = Tweet.convert(jsonPayload);
                    //if (tweetResponse is Tweet) {
                    //    return tweetResponse.freeze();
                    //} else {
                    //    error err = error(TWITTER_ERROR_CODE, { ^"cause": tweetResponse,
                    //        message: "Error in json to Tweet record conversion" });
                    //    return err;
                    //}
                } else {
                    return setResponseError(jsonPayload);
                }
            } else {
                error err = error(IO_ERROR_CODE, { ^"cause": jsonPayload,
                    message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(TWITTER_ERROR_CODE, { ^"cause": httpResponse,
                message: "Error occurred while invoking the Twitter REST API" });
            return err;
        }
    }
    return ();
}
