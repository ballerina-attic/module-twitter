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

import ballerina/encoding;
import ballerina/http;

# The Twitter client object.
public type Client client object {

    http:Client twitterClient;
    TwitterCredential twitterCredential;

    public function __init(TwitterConfiguration twitterConfig) {
        self.twitterClient = new(TWITTER_API_URL, twitterConfig.clientConfig);
        self.twitterCredential = {
            accessToken: twitterConfig.accessToken,
            accessTokenSecret: twitterConfig.accessTokenSecret,
            consumerKey: twitterConfig.consumerKey,
            consumerSecret: twitterConfig.consumerSecret
        };
    }

    # Updates the authenticating user's current status, also known as Tweeting.
    #
    # + status - The text of status update
    # + return - If success, returns `twitter:Status` object, else returns `error`.
    public remote function tweet(string status) returns @tainted Status|error {
        var encodedStatusValue = encoding:encodeUriComponent(status, UTF_8);
        if (encodedStatusValue is error) {
            return prepareError("Error occurred while encoding the status.");
        }

        string urlParams = "status=" + <string>encodedStatusValue;

        var headerValue = generateAuthorizationHeader(POST, UPDATE_ENDPOINT, urlParams, self.twitterCredential);
        if (headerValue is error) {
            return prepareError("Error occurred while generating authorization header.");
        }

        http:Request request = new;
        request.setHeader("Authorization", <string>headerValue);
        string requestPath = UPDATE_ENDPOINT + "?" + urlParams;

        var httpResponse = self.twitterClient->post(requestPath, request);
        if (httpResponse is http:Response) {
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                int statusCode = httpResponse.statusCode;
                if (statusCode == http:STATUS_OK) {
                    return convertToStatus(jsonPayload);
                } else {
                    return prepareErrorResponse(jsonPayload);
                }
            } else {
                return prepareError("Error occurred while accessing the JSON payload of the response.");
            }
        } else {
            return prepareError("Error occurred while invoking the REST API.");
        }
    }

    //# Retweet a tweet.
    //#
    //# + id - The numerical ID of the desired status
    //# + return - If success, returns Status object, else returns error.
    //public remote function retweet(int id) returns @tainted Status|error {
    //    http:Request request = new;
    //    string oauthStr = constructOAuthParams(self.clientId, self.accessToken);
    //
    //    string tweetPath = RETWEET_ENDPOINT + id.toString() + JSON;
    //    var requestHeaders = constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret,
    //        self.accessToken, self.accessTokenSecret, oauthStr);
    //    if (requestHeaders is error) {
    //        return prepareError("Error occurred while encoding parameters when constructing request headers.");
    //    } else {
    //        var httpResponse = self.twitterClient->post(tweetPath, request);
    //        if (httpResponse is http:Response) {
    //            int statusCode = httpResponse.statusCode;
    //            var jsonPayload = httpResponse.getJsonPayload();
    //            if (jsonPayload is json) {
    //                if (statusCode == http:STATUS_OK) {
    //                    return convertToStatus(jsonPayload);
    //                } else {
    //                    return setResponseError(jsonPayload);
    //                }
    //            } else {
    //                return prepareError("Error occurred while accessing the JSON payload of the response.");
    //            }
    //        } else {
    //            return prepareError("Error occurred while invoking the REST API.");
    //        }
    //    }
    //}
    //
    //# Untweet a retweeted status.
    //#
    //# + id - The numerical ID of the desired status
    //# + return - If success, returns Status object, else returns error.
    //public remote function unretweet(int id) returns @tainted Status|error {
    //    http:Request request = new;
    //    string oauthStr = constructOAuthParams(self.clientId, self.accessToken);
    //
    //    string tweetPath = UN_RETWEET_ENDPOINT + id.toString() + JSON;
    //    var requestHeaders = constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret,
    //        self.accessToken, self.accessTokenSecret, oauthStr);
    //    if (requestHeaders is error) {
    //        return prepareError("Error occurred while encoding parameters when constructing request headers.");
    //    } else {
    //        var httpResponse = self.twitterClient->post(tweetPath, request);
    //        if (httpResponse is http:Response) {
    //            int statusCode = httpResponse.statusCode;
    //            var jsonPayload = httpResponse.getJsonPayload();
    //            if (jsonPayload is json) {
    //                if (statusCode == http:STATUS_OK) {
    //                    return convertToStatus(jsonPayload);
    //                } else {
    //                    return setResponseError(jsonPayload);
    //                }
    //            } else {
    //                return prepareError("Error occurred while accessing the JSON payload of the response.");
    //            }
    //        } else {
    //            return prepareError("Error occurred while invoking the REST API.");
    //        }
    //    }
    //}
    //
    //# Search for tweets.
    //#
    //# + queryStr - Query string to retrieve the related tweets
    //# + searchRequest - It contains optional params that is needed for search operation(tweetsCount)
    //# + return - If success, Status[] object, else returns error
    //public remote function search(string queryStr, SearchRequest searchRequest) returns @tainted Status[]|error {
    //    string tweetPath = SEARCH_ENDPOINT;
    //    string encodedQueryValue = check encoding:encodeUriComponent(queryStr, UTF_8);
    //    string urlParams = "q=" + encodedQueryValue + "&";
    //    string count = searchRequest.tweetsCount;
    //    string oauthStr = constructOAuthParams(self.clientId, self.accessToken) + urlParams;
    //    if (count != "") {
    //        oauthStr = "count=" + count + "&" + oauthStr;
    //    }
    //
    //    http:Request request = new;
    //    var requestHeaders = constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret, self.accessToken,
    //        self.accessTokenSecret, oauthStr);
    //    if (requestHeaders is error) {
    //        return prepareError("Error occurred while encoding parameters when constructing request headers.");
    //    } else {
    //        tweetPath = tweetPath + "?" + urlParams;
    //        if (count != "") {
    //            tweetPath =  tweetPath + "count=" + count;
    //        }
    //
    //        var httpResponse = self.twitterClient->get(tweetPath, request);
    //        if (httpResponse is http:Response) {
    //            int statusCode = httpResponse.statusCode;
    //            var jsonPayload = httpResponse.getJsonPayload();
    //            if (jsonPayload is json) {
    //                if (statusCode == http:STATUS_OK) {
    //                    Status[] searchResponse = [];
    //                    if (jsonPayload.statuses is json) {
    //                        searchResponse = convertToStatuses(<json[]>jsonPayload.statuses);
    //                    }
    //                    return searchResponse;
    //                } else {
    //                    return setResponseError(jsonPayload);
    //                }
    //            } else {
    //                return prepareError("Error occurred while accessing the JSON payload of the response.");
    //            }
    //        } else {
    //            return prepareError("Error occurred while invoking the REST API.");
    //        }
    //    }
    //}
    //
    //# Retrive a single status.
    //#
    //# + id - The numerical ID of the desired status
    //# + return - If success, returns Status object, else returns error
    //public remote function getTweet(int id) returns @tainted Status|error {
    //    http:Request request = new;
    //    string tweetPath = SHOW_STATUS_ENDPOINT;
    //    string urlParams = ID + id.toString();
    //    string oauthStr = urlParams + "&" + constructOAuthParams(self.clientId, self.accessToken);
    //
    //    var requestHeaders = constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret,
    //        self.accessToken, self.accessTokenSecret, oauthStr);
    //    if (requestHeaders is error) {
    //        return prepareError("Error occurred while encoding parameters when constructing request headers.");
    //    } else {
    //        tweetPath = tweetPath + "?" + urlParams;
    //        var httpResponse = self.twitterClient->get(tweetPath, request);
    //        if (httpResponse is http:Response) {
    //            int statusCode = httpResponse.statusCode;
    //            var jsonPayload = httpResponse.getJsonPayload();
    //            if (jsonPayload is json) {
    //                if (statusCode == http:STATUS_OK) {
    //                    return convertToStatus(jsonPayload);
    //                } else {
    //                    return setResponseError(jsonPayload);
    //                }
    //            } else {
    //                return prepareError("Error occurred while accessing the JSON payload of the response.");
    //            }
    //        } else {
    //            return prepareError("Error occurred while invoking the REST API.");
    //        }
    //    }
    //}
    //
    //# Distroy a status.
    //#
    //# + id - The numerical ID of the desired status
    //# + return - If success, returns Status object, else returns error
    //public remote function deleteTweet(int id) returns @tainted Status|error {
    //    http:Request request = new;
    //    string oauthStr = constructOAuthParams(self.clientId, self.accessToken);
    //
    //    string tweetPath = DESTROY_STATUS_ENDPOINT + id.toString() + JSON;
    //    var requestHeaders = constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret,
    //        self.accessToken, self.accessTokenSecret, oauthStr);
    //    if (requestHeaders is error) {
    //        return prepareError("Error occurred while encoding parameters when constructing request headers.");
    //    } else {
    //        var httpResponse = self.twitterClient->post(tweetPath, request);
    //        if (httpResponse is http:Response) {
    //            int statusCode = httpResponse.statusCode;
    //            var jsonPayload = httpResponse.getJsonPayload();
    //            if (jsonPayload is json) {
    //                if (statusCode == http:STATUS_OK) {
    //                    return convertToStatus(jsonPayload);
    //                } else {
    //                    return setResponseError(jsonPayload);
    //                }
    //            } else {
    //                return prepareError("Error occurred while accessing the JSON payload of the response.");
    //            }
    //        } else {
    //            return prepareError("Error occurred while invoking the REST API.");
    //        }
    //    }
    //}
};

type TwitterCredential record {
    string accessToken;
    string accessTokenSecret;
    string consumerKey;
    string consumerSecret;
};

# The Twitter connector configurations.
#
# + accessToken - The access token of the Twitter account
# + accessTokenSecret - The access token secret of the Twitter account
# + consumerKey - The consumer key of the Twitter account
# + consumerSecret - The consumer secret of the Twitter account
# + clientConfig - HTTP client endpoint configurations
public type TwitterConfiguration record {
    string accessToken;
    string accessTokenSecret;
    string consumerKey;
    string consumerSecret;
    http:ClientConfiguration clientConfig = {};
};
