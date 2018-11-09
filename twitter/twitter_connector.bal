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

function TwitterConnector::tweet(string status, string... args) returns Status|error {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    http:Request request;

    string mediaIds = "";
    string attachmentUrl = "";

    if ((lengthof args) > 0) {
        mediaIds = args[0];
    }
    if ((lengthof args) > 1) {
        attachmentUrl = args[1];
    }

    string tweetPath = UPDATE_ENDPOINT;
    string encodedStatusValue = check http:encode(status, UTF_8);
    string urlParams = STATUS + encodedStatusValue + "&";
    string oauthStr;

    if (attachmentUrl != "") {
        string encodedAttachmentValue = check http:encode(attachmentUrl, UTF_8);
        urlParams = urlParams + ATTACHMENT_URL + encodedAttachmentValue + "&";
        oauthStr = ATTACHMENT_URL + encodedAttachmentValue + "&";
    }

    if (mediaIds != "") {
        string encodedMediaValue = check http:encode(mediaIds, UTF_8);
        urlParams = urlParams + MEDIA_IDS + encodedMediaValue + "&";
        oauthStr = oauthStr + MEDIA_IDS + encodedMediaValue + "&";
    }
    oauthStr = oauthStr + constructOAuthParams(self.clientId, self.accessToken) + STATUS + encodedStatusValue + "&";

    constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    tweetPath = tweetPath + "?" + urlParams;
    var httpResponse = clientEndpoint->post(tweetPath, request);
    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var twitterJSONResponse = response.getJsonPayload();
            match twitterJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        Status twitterResponse = convertToStatus(jsonResponse);
                        return twitterResponse;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function TwitterConnector::retweet(int id) returns Status|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    http:Request request;
    string oauthStr = constructOAuthParams(self.clientId, self.accessToken);

    string tweetPath = RETWEET_ENDPOINT + id + JSON;
    constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    var httpResponse = clientEndpoint->post(tweetPath, request);
    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var twitterJSONResponse = response.getJsonPayload();
            match twitterJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        Status twitterResponse = convertToStatus(jsonResponse);
                        return twitterResponse;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function TwitterConnector::unretweet(int id) returns Status|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    http:Request request;
    string oauthStr = constructOAuthParams(self.clientId, self.accessToken);

    string tweetPath = UN_RETWEET_ENDPOINT + id + JSON;
    constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    var httpResponse = clientEndpoint->post(tweetPath, request);
    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var twitterJSONResponse = response.getJsonPayload();
            match twitterJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        Status twitterResponse = convertToStatus(jsonResponse);
                        return twitterResponse;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function TwitterConnector::search(string queryStr, SearchRequest searchRequest) returns Status[]|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string tweetPath = SEARCH_ENDPOINT;
    string encodedQueryValue = check http:encode(queryStr, UTF_8);
    string urlParams = "q=" + encodedQueryValue + "&";
    string count = searchRequest.tweetsCount;
    string oauthStr = constructOAuthParams(self.clientId, self.accessToken) + urlParams;
    if (count != null) {
        oauthStr = "count=" + count + "&" + oauthStr;
    }

    http:Request request;
    constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    tweetPath = tweetPath + "?" + urlParams;
    if (count != "") {
        tweetPath =  tweetPath + "count=" + count;
    }

    var httpResponse = clientEndpoint->get(tweetPath, message = request);
    Status[] searchResponse = [];
    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var twitterJSONResponse = response.getJsonPayload();
            match twitterJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        if (jsonResponse.statuses != null) {
                            searchResponse = convertToStatuses(jsonResponse.statuses);
                        }
                        return searchResponse;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function TwitterConnector::showStatus(int id) returns Status|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    http:Request request;
    string tweetPath = SHOW_STATUS_ENDPOINT;
    string urlParams = ID + id;
    string oauthStr = urlParams + "&" + constructOAuthParams(self.clientId, self.accessToken);

    constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    tweetPath = tweetPath + "?" + urlParams;
    var httpResponse = clientEndpoint->get(tweetPath, message = request);
    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var twitterJSONResponse = response.getJsonPayload();
            match twitterJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        Status twitterResponse = convertToStatus(jsonResponse);
                        return twitterResponse;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function TwitterConnector::destroyStatus(int id) returns Status|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    http:Request request;
    string oauthStr = constructOAuthParams(self.clientId, self.accessToken);

    string tweetPath = DESTROY_STATUS_ENDPOINT + id + JSON;
    constructRequestHeaders(request, POST, tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    var httpResponse = clientEndpoint->post(tweetPath, request);
    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var twitterJSONResponse = response.getJsonPayload();
            match twitterJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        Status twitterResponse = convertToStatus(jsonResponse);
                        return twitterResponse;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function TwitterConnector::getClosestTrendLocations(float lat, float long)
                               returns Location[]|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string tweetPath = TRENDS_ENDPOINT;
    string urlParams = LAT + lat + LONG + long;
    string oauthStr = urlParams.substring(1, urlParams.length()) + "&" + constructOAuthParams(self.clientId,
            self.accessToken);
    http:Request request;
    constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    tweetPath = tweetPath + "?" + urlParams.substring(1, urlParams.length());

    var httpResponse = clientEndpoint->get(tweetPath, message = request);
    Location[] locations = [];
    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var twitterJSONResponse = response.getJsonPayload();
            match twitterJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        locations = convertToLocations(jsonResponse);
                        return locations;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function TwitterConnector::getTopTrendsByPlace(int locationId) returns Trends[]|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string tweetPath = TRENDS_PLACE_ENDPOINT;
    string urlParams = ID + locationId;
    string oauthStr = urlParams + "&" + constructOAuthParams(self.clientId, self.accessToken);

    http:Request request;
    constructRequestHeaders(request, GET, tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    tweetPath = tweetPath + "?" + urlParams;

    var httpResponse = clientEndpoint->get(tweetPath, message = request);
    Trends[] trends = [];
    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var twitterJSONResponse = response.getJsonPayload();
            match twitterJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        trends = convertTrends(jsonResponse);
                        return trends;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function setResponseError(int statusCode, json jsonResponse) returns error {
    error err = {};
    err.message = jsonResponse.errors[0].message.toString();
    err.statusCode = statusCode;
    return err;
}
