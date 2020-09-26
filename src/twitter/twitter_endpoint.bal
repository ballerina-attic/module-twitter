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

import ballerina/encoding;
import ballerina/http;

# Twitter Client object.
#
# + accessToken - The access token of the Twitter account
# + accessTokenSecret - The access token secret of the Twitter account
# + clientId - The consumer key of the Twitter account
# + clientSecret - The consumer secret of the Twitter account
# + twitterClient - HTTP Client endpoint
public client class Client {

    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:Client twitterClient;

    public function init(TwitterConfiguration twitterConfig) {
        self.twitterClient = new(TWITTER_API_URL, twitterConfig.clientConfig);
        self.accessToken = twitterConfig.accessToken;
        self.accessTokenSecret = twitterConfig.accessTokenSecret;
        self.clientId = twitterConfig.clientId;
        self.clientSecret = twitterConfig.clientSecret;
    }

    # Update the authenticated user's current status (If you want to provide attachment, you can use
    # mediaIds or attachmentUrl).
    #
    # + status - The text of status update
    # + args - The user parameters as args
    # + return - If success, returns Status object, else returns error.
    public remote function tweet(string status, string... args) returns @tainted Status|error {
        http:Request request = new;

        string mediaIds = "";
        string attachmentUrl = "";

        if (args.length() > 0) {
            mediaIds = args[0];
        }
        if (args.length() > 1) {
            attachmentUrl = args[1];
        }

        string tweetPath = UPDATE_ENDPOINT;
        string encodedStatusValue = check encoding:encodeUriComponent(status, UTF_8);
        string urlParams = STATUS + encodedStatusValue + "&";
        string oauthStr = "";

        if (attachmentUrl != "") {
            string encodedAttachmentValue = check encoding:encodeUriComponent(attachmentUrl, UTF_8);
            urlParams = urlParams + ATTACHMENT_URL + encodedAttachmentValue + "&";
            oauthStr = ATTACHMENT_URL + encodedAttachmentValue + "&";
        }

        if (mediaIds != "") {
            string encodedMediaValue = check encoding:encodeUriComponent(mediaIds, UTF_8);
            urlParams = urlParams + MEDIA_IDS + encodedMediaValue + "&";
            oauthStr = oauthStr + MEDIA_IDS + encodedMediaValue + "&";
        }
        oauthStr = oauthStr + constructOAuthParams(self.clientId, self.accessToken) + STATUS + encodedStatusValue + "&";

        var requestHeaders = constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthStr);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR_CODE,
                              message = "Error occurred while encoding parameters when constructing request headers");
            return err;
        } else {
            tweetPath = tweetPath + "?" + urlParams;
            var httpResponse = self.twitterClient->post(tweetPath, request);
            if (httpResponse is http:Response) {
                int statusCode = httpResponse.statusCode;
                var jsonPayload = httpResponse.getJsonPayload();
                if (jsonPayload is json) {
                    if (statusCode == http:STATUS_OK) {
                        return convertToStatus(jsonPayload);
                    } else {
                        return setResponseError(jsonPayload);
                    }
                } else {
                    error err = error(TWITTER_ERROR_CODE,
                                      message = "Error occurred while accessing the JSON payload of the response");
                    return err;
                }
            } else {
                error err = error(TWITTER_ERROR_CODE,
                                  message = "Error occurred while invoking the REST API");
                return err;
            }
        }
    }

    # Retweet a tweet.
    #
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns error.
    public remote function retweet(int id) returns @tainted Status|error {
        http:Request request = new;
        string oauthStr = constructOAuthParams(self.clientId, self.accessToken);

        string tweetPath = RETWEET_ENDPOINT + id.toString() + JSON;
        var requestHeaders = constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthStr);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR_CODE,
                              message = "Error occurred while encoding parameters when constructing request headers");
            return err;
        } else {
            var httpResponse = self.twitterClient->post(tweetPath, request);
            if (httpResponse is http:Response) {
                int statusCode = httpResponse.statusCode;
                var jsonPayload = httpResponse.getJsonPayload();
                if (jsonPayload is json) {
                    if (statusCode == http:STATUS_OK) {
                        return convertToStatus(jsonPayload);
                    } else {
                        return setResponseError(jsonPayload);
                    }
                } else {
                    error err = error(TWITTER_ERROR_CODE,
                                      message = "Error occurred while accessing the JSON payload of the response");
                    return err;
                }
            } else {
                error err = error(TWITTER_ERROR_CODE, message = "Error occurred while invoking the REST API");
                return err;
            }
        }
    }

    # Untweet a retweeted status.
    #
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns error.
    public remote function unretweet(int id) returns @tainted Status|error {
        http:Request request = new;
        string oauthStr = constructOAuthParams(self.clientId, self.accessToken);

        string tweetPath = UN_RETWEET_ENDPOINT + id.toString() + JSON;
        var requestHeaders = constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthStr);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR_CODE,
                              message = "Error occurred while encoding parameters when constructing request headers");
            return err;
        } else {
            var httpResponse = self.twitterClient->post(tweetPath, request);
            if (httpResponse is http:Response) {
                int statusCode = httpResponse.statusCode;
                var jsonPayload = httpResponse.getJsonPayload();
                if (jsonPayload is json) {
                    if (statusCode == http:STATUS_OK) {
                        return convertToStatus(jsonPayload);
                    } else {
                        return setResponseError(jsonPayload);
                    }
                } else {
                    error err = error(TWITTER_ERROR_CODE,
                                      message = "Error occurred while accessing the JSON payload of the response");
                    return err;
                }
            } else {
                error err = error(TWITTER_ERROR_CODE, message = "Error occurred while invoking the REST API");
                return err;
            }
        }
    }

    # Search for tweets.
    #
    # + queryStr - Query string to retrieve the related tweets
    # + searchRequest - It contains optional params that is needed for search operation(tweetsCount)
    # + return - If success, Status[] object, else returns error
    public remote function search(string queryStr, SearchRequest searchRequest) returns @tainted Status[]|error {
        string tweetPath = SEARCH_ENDPOINT;
        string encodedQueryValue = check encoding:encodeUriComponent(queryStr, UTF_8);
        string urlParams = "q=" + encodedQueryValue + "&";
        string count = searchRequest.tweetsCount;
        string oauthStr = constructOAuthParams(self.clientId, self.accessToken) + urlParams;
        if (count != "") {
            oauthStr = "count=" + count + "&" + oauthStr;
        }

        http:Request request = new;
        var requestHeaders = constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret, self.accessToken,
            self.accessTokenSecret, oauthStr);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR_CODE,
                              message = "Error occurred while encoding parameters when constructing request headers");
            return err;
        } else {
            tweetPath = tweetPath + "?" + urlParams;
            if (count != "") {
                tweetPath =  tweetPath + "count=" + count;
            }

            var httpResponse = self.twitterClient->get(tweetPath, request);
            if (httpResponse is http:Response) {
                int statusCode = httpResponse.statusCode;
                var jsonPayload = httpResponse.getJsonPayload();
                if (jsonPayload is json) {
                    if (statusCode == http:STATUS_OK) {
                        Status[] searchResponse = [];
                        if (jsonPayload.statuses is json) {
                            searchResponse = convertToStatuses(<json[]>jsonPayload.statuses);
                        }
                        return searchResponse;
                    } else {
                        return setResponseError(jsonPayload);
                    }
                } else {
                    error err = error(TWITTER_ERROR_CODE,
                                      message = "Error occurred while accessing the JSON payload of the response");
                    return err;
                }
            } else {
                error err = error(TWITTER_ERROR_CODE, message = "Error occurred while invoking the REST API");
                return err;
            }
        }
    }

    # Retrive a single status.
    #
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns error
    public remote function showStatus(int id) returns @tainted Status|error {
        http:Request request = new;
        string tweetPath = SHOW_STATUS_ENDPOINT;
        string urlParams = ID + id.toString();
        string oauthStr = urlParams + "&" + constructOAuthParams(self.clientId, self.accessToken);

        var requestHeaders = constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthStr);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR_CODE,
                              message = "Error occurred while encoding parameters when constructing request headers");
            return err;
        } else {
            tweetPath = tweetPath + "?" + urlParams;
            var httpResponse = self.twitterClient->get(tweetPath, request);
            if (httpResponse is http:Response) {
                int statusCode = httpResponse.statusCode;
                var jsonPayload = httpResponse.getJsonPayload();
                if (jsonPayload is json) {
                    if (statusCode == http:STATUS_OK) {
                        return convertToStatus(jsonPayload);
                    } else {
                        return setResponseError(jsonPayload);
                    }
                } else {
                    error err = error(TWITTER_ERROR_CODE,
                                      message = "Error occurred while accessing the JSON payload of the response");
                    return err;
                }
            } else {
                error err = error(TWITTER_ERROR_CODE, message = "Error occurred while invoking the REST API");
                return err;
            }
        }
    }

    # Distroy a status.
    #
    # + id - The numerical ID of the desired status
    # + return - If success, returns Status object, else returns error
    public remote function destroyStatus(int id) returns @tainted Status|error {
        http:Request request = new;
        string oauthStr = constructOAuthParams(self.clientId, self.accessToken);

        string tweetPath = DESTROY_STATUS_ENDPOINT + id.toString() + JSON;
        var requestHeaders = constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthStr);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR_CODE,
                              message = "Error occurred while encoding parameters when constructing request headers");
            return err;
        } else {
            var httpResponse = self.twitterClient->post(tweetPath, request);
            if (httpResponse is http:Response) {
                int statusCode = httpResponse.statusCode;
                var jsonPayload = httpResponse.getJsonPayload();
                if (jsonPayload is json) {
                    if (statusCode == http:STATUS_OK) {
                        return convertToStatus(jsonPayload);
                    } else {
                        return setResponseError(jsonPayload);
                    }
                } else {
                    error err = error(TWITTER_ERROR_CODE,
                                      message = "Error occurred while accessing the JSON payload of the response");
                    return err;
                }
            } else {
                error err = error(TWITTER_ERROR_CODE, message = "Error occurred while invoking the REST API");
                return err;
            }
        }
    }

    # Retrive closest trend locations.
    #
    # + lat - Latitude of the location
    # + long - Longitude of the location
    # + return - If success, returns Location[] object, else returns error
    public remote function getClosestTrendLocations(float lat, float long) returns @tainted Location[]|error {
        string tweetPath = TRENDS_ENDPOINT;
        string urlParams = LAT + lat.toString() + LONG + long.toString();
        string oauthStr = urlParams.substring(1, urlParams.length()) + "&" + constructOAuthParams(self.clientId,
                self.accessToken);
        http:Request request = new;
        var requestHeaders = constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthStr);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR_CODE,
                              message = "Error occurred while encoding parameters when constructing request headers");
            return err;
        } else {
            tweetPath = tweetPath + "?" + urlParams.substring(1, urlParams.length());

            var httpResponse = self.twitterClient->get(tweetPath, request);
            if (httpResponse is http:Response) {
                int statusCode = httpResponse.statusCode;
                var jsonPayload = httpResponse.getJsonPayload();
                if (jsonPayload is json) {
                    if (statusCode == http:STATUS_OK) {
                        return convertToLocations(<json[]>jsonPayload);
                    } else {
                        return setResponseError(jsonPayload);
                    }
                } else {
                    error err = error(TWITTER_ERROR_CODE,
                                      message = "Error occurred while accessing the JSON payload of the response");
                    return err;
                }
            } else {
                error err = error(TWITTER_ERROR_CODE, message = "Error occurred while invoking the REST API");
                return err;
            }
        }
    }

    # Retrive top trends by place.
    #
    # + locationId - Where On Earth ID of the location to return trending information for
    # + return - If success, returns Trends[] object, else returns error
    public remote function getTopTrendsByPlace(int locationId) returns @tainted Trends[]|error {
        string tweetPath = TRENDS_PLACE_ENDPOINT;
        string urlParams = ID + locationId.toString();
        string oauthStr = urlParams + "&" + constructOAuthParams(self.clientId, self.accessToken);

        http:Request request = new;
        var requestHeaders = constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret,
            self.accessToken, self.accessTokenSecret, oauthStr);
        if (requestHeaders is error) {
            error err = error(TWITTER_ERROR_CODE,
                              message = "Error occurred while encoding parameters when constructing request headers");
            return err;
        } else {
            tweetPath = tweetPath + "?" + urlParams;

            var httpResponse = self.twitterClient->get(tweetPath, request);
            if (httpResponse is http:Response) {
                int statusCode = httpResponse.statusCode;
                var jsonPayload = httpResponse.getJsonPayload();
                if (jsonPayload is json) {
                    if (statusCode == http:STATUS_OK) {
                        return convertTrends(jsonPayload);
                    } else {
                        return setResponseError(jsonPayload);
                    }
                } else {
                    error err = error(TWITTER_ERROR_CODE,
                                      message = "Error occurred while accessing the JSON payload of the response");
                    return err;
                }
            } else {
                error err = error(TWITTER_ERROR_CODE, message = "Error occurred while invoking the REST API");
                return err;
            }
        }
    }
};

# Twitter Connector configurations can be setup here.
#
# + accessToken - The access token of the Twitter account
# + accessTokenSecret - The access token secret of the Twitter account
# + clientId - The consumer key of the Twitter account
# + clientSecret - The consumer secret of the Twitter account
# + clientConfig - Client endpoint configurations provided by the user
public type TwitterConfiguration record {
    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:ClientConfiguration clientConfig = {};
};
