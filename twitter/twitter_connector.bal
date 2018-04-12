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
import ballerina/mime;

public function TwitterConnector::tweet (string status, string mediaIds, string attachmentUrl)
    returns Status | TwitterError {

    endpoint http:Client clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};

    string tweetPath = "/1.1/statuses/update.json";
    string encodedStatusValue = check http:encode(status, "UTF-8");
    string urlParams =  "status=" + encodedStatusValue + "&";
    string oauthStr;

    if (attachmentUrl != "") {
        string encodedAttachmentValue = check http:encode(attachmentUrl, "UTF-8");
        urlParams = urlParams + "attachment_url=" + encodedAttachmentValue + "&";
        oauthStr = "attachment_url=" + encodedAttachmentValue + "&";
    }

    if (mediaIds != "") {
        string encodedMediaValue = check http:encode(mediaIds, "UTF-8");
        urlParams = urlParams + "media_ids=" + encodedMediaValue + "&";
        oauthStr = oauthStr + "media_ids=" + encodedMediaValue + "&";
    }
    oauthStr = oauthStr + constructOAuthParams(self.clientId, self.accessToken) + "status=" + encodedStatusValue + "&";

    constructRequestHeaders(request, "POST", tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    tweetPath = tweetPath + "?" + urlParams;
    var httpResponse = clientEndpoint -> post(tweetPath, request);
    match httpResponse {
        http:HttpConnectorError err => {
            twitterError.errorMessage = err.message;
            twitterError.statusCode = err.statusCode;
            return twitterError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var twitterJSONResponse = response.getJsonPayload();
                                    match twitterJSONResponse {
                                        mime:EntityError err => {
                                            twitterError.errorMessage = err.message;
                                            return twitterError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                Status twitterResponse = convertToStatus(jsonResponse);
                                                return twitterResponse;
                                            } else {
                                                twitterError.errorMessage = jsonResponse.errors[0].message.toString() but { () => "" };
                                                twitterError.statusCode = statusCode;
                                                return twitterError;
                                            }
                                        }
                                    }
        }
    }
}

public function TwitterConnector::retweet (string id) returns Status | TwitterError {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};
    string oauthStr = constructOAuthParams(self.clientId, self.accessToken);

    string tweetPath = "/1.1/statuses/retweet/" + id + ".json";
    constructRequestHeaders(request, "POST", tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    var httpResponse = clientEndpoint -> post(tweetPath, request);
    match httpResponse {
        http:HttpConnectorError err => {
            twitterError.errorMessage = err.message;
            twitterError.statusCode = err.statusCode;
            return twitterError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var twitterJSONResponse = response.getJsonPayload();
                                    match twitterJSONResponse {
                                        mime:EntityError err => {
                                            twitterError.errorMessage = err.message;
                                            return twitterError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                Status twitterResponse = convertToStatus(jsonResponse);
                                                return twitterResponse;
                                            } else {
                                                twitterError.errorMessage = jsonResponse.errors[0].message.toString()
                                                                            but { () => "" };
                                                twitterError.statusCode = statusCode;
                                                return twitterError;
                                            }
                                        }
                                    }
        }
    }
}

public function TwitterConnector::unretweet (string id) returns Status | TwitterError {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};
    string oauthStr = constructOAuthParams(self.clientId, self.accessToken);

    string tweetPath = "/1.1/statuses/unretweet/" + id + ".json";
    constructRequestHeaders(request, "POST", tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    var httpResponse = clientEndpoint -> post(tweetPath, request);
    match httpResponse {
        http:HttpConnectorError err => {
            twitterError.errorMessage = err.message;
            twitterError.statusCode = err.statusCode;
            return twitterError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var twitterJSONResponse = response.getJsonPayload();
                                    match twitterJSONResponse {
                                        mime:EntityError err => {
                                            twitterError.errorMessage = err.message;
                                            return twitterError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                Status twitterResponse = convertToStatus(jsonResponse);
                                                return twitterResponse;
                                            } else {
                                                twitterError.errorMessage = jsonResponse.errors[0].message.toString()
                                                                            but { () => "" };
                                                twitterError.statusCode = statusCode;
                                                return twitterError;
                                            }
                                        }
                                    }
        }
    }
}

public function TwitterConnector::search (string queryStr) returns Status[] | TwitterError {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    TwitterError twitterError = {};
    string tweetPath = "/1.1/search/tweets.json";
    string encodedQueryValue = check http:encode(queryStr, "UTF-8");
    string urlParams = "q=" + encodedQueryValue + "&";
    string oauthStr = constructOAuthParams(self.clientId, self.accessToken) + urlParams;

    http:Request request;
    constructRequestHeaders(request, "GET", tweetPath, self.clientId, self.clientSecret, self.accessToken, self.accessTokenSecret,
                            oauthStr);
    tweetPath = tweetPath + "?" + urlParams;

    var httpResponse = clientEndpoint -> get(tweetPath, request);
    Status[] searchResponse = [];
    match httpResponse {
        http:HttpConnectorError err => { twitterError.errorMessage = err.message;
                                         twitterError.statusCode = err.statusCode;
                                         return twitterError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var twitterJSONResponse = response.getJsonPayload();
                                    match twitterJSONResponse {
                                        mime:EntityError err => {
                                            twitterError.errorMessage = err.message;
                                            return twitterError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                if (jsonResponse.statuses != null) {
                                                    searchResponse = convertToStatuses(jsonResponse.statuses);
                                                }
                                                return searchResponse;
                                            } else {
                                                twitterError.errorMessage = jsonResponse.errors[0].message.toString()
                                                                            but { () => "" };
                                                twitterError.statusCode = statusCode;
                                                return twitterError;
                                            }
                                        }
                                    }
        }
    }
}

public function TwitterConnector::showStatus (string id) returns Status | TwitterError {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};
    string tweetPath = "/1.1/statuses/show.json";
    string urlParams = "id=" + id;
    string oauthStr = urlParams + "&" + constructOAuthParams(self.clientId, self.accessToken);

    constructRequestHeaders(request, "GET", tweetPath, self.clientId, self.clientSecret, self.accessToken, self.accessTokenSecret,
                            oauthStr);
    tweetPath = tweetPath + "?" + urlParams;
    var httpResponse = clientEndpoint -> get(tweetPath, request);
    match httpResponse {
        http:HttpConnectorError err => {
            twitterError.errorMessage = err.message;
            twitterError.statusCode = err.statusCode;
            return twitterError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var twitterJSONResponse = response.getJsonPayload();
                                    match twitterJSONResponse {
                                        mime:EntityError err => {
                                            twitterError.errorMessage = err.message;
                                            return twitterError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                Status twitterResponse = convertToStatus(jsonResponse);
                                                return twitterResponse;
                                            } else {
                                                twitterError.errorMessage = jsonResponse.errors[0].message.toString()
                                                                            but { () => "" };
                                                twitterError.statusCode = statusCode;
                                                return twitterError;
                                            }
                                        }
                                    }
        }
    }
}

public function TwitterConnector::destroyStatus (string id) returns Status | TwitterError {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};
    string oauthStr = constructOAuthParams(self.clientId, self.accessToken);

    string tweetPath = "/1.1/statuses/destroy/" + id + ".json";
    constructRequestHeaders(request, "POST", tweetPath, self.clientId, self.clientSecret, self.accessToken, self.accessTokenSecret,
                            oauthStr);
    var httpResponse = clientEndpoint -> post(tweetPath, request);
    match httpResponse {
        http:HttpConnectorError err => {
            twitterError.errorMessage = err.message;
            twitterError.statusCode = err.statusCode;
            return twitterError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var twitterJSONResponse = response.getJsonPayload();
                                    match twitterJSONResponse {
                                        mime:EntityError err => {
                                            twitterError.errorMessage = err.message;
                                            return twitterError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                Status twitterResponse = convertToStatus(jsonResponse);
                                                return twitterResponse;
                                            } else {
                                                twitterError.errorMessage = jsonResponse.errors[0].message.toString()
                                                                            but { () => "" };
                                                twitterError.statusCode = statusCode;
                                                return twitterError;
                                            }
                                        }
                                    }
        }
    }
}

public function TwitterConnector::getClosestTrendLocations (string lat, string long)
returns Location [] | TwitterError {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    TwitterError twitterError = {};
    string tweetPath = "/1.1/trends/closest.json";
    string urlParams =  "&lat=" + lat + "&long=" + long;
    string oauthStr = urlParams.subString(1, urlParams.length()) + "&" + constructOAuthParams(self.clientId, self.accessToken);
    http:Request request;
    constructRequestHeaders(request, "GET", tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    tweetPath = tweetPath + "?" + urlParams.subString(1, urlParams.length());

    var httpResponse = clientEndpoint -> get(tweetPath, request);
    Location[] locations = [];
    match httpResponse {
        http:HttpConnectorError err => {
            twitterError.errorMessage = err.message;
            twitterError.statusCode = err.statusCode;
            return twitterError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var twitterJSONResponse = response.getJsonPayload();
                                    match twitterJSONResponse {
                                        mime:EntityError err => {
                                            twitterError.errorMessage = err.message;
                                            return twitterError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                locations = convertToLocations(jsonResponse);
                                                return locations;
                                            } else {
                                                twitterError.errorMessage = jsonResponse.errors[0].message.toString()
                                                                            but { () => "" };
                                                twitterError.statusCode = statusCode;
                                                return twitterError;
                                            }
                                        }
                                    }
        }
    }
}

public function TwitterConnector::getTopTrendsByPlace (string locationId) returns Trends[] | TwitterError {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    TwitterError twitterError = {};
    string tweetPath = "/1.1/trends/place.json";
    string urlParams = "id=" + locationId;
    string oauthStr = urlParams + "&" + constructOAuthParams(self.clientId, self.accessToken);

    http:Request request;
    constructRequestHeaders(request, "GET", tweetPath, self.clientId, self.clientSecret, self.accessToken,
        self.accessTokenSecret, oauthStr);
    tweetPath = tweetPath + "?" + urlParams;

    var httpResponse = clientEndpoint -> get(tweetPath, request);
    Trends[] trends = [];
    match httpResponse {
        http:HttpConnectorError err => {
            twitterError.errorMessage = err.message;
            twitterError.statusCode = err.statusCode;
            return twitterError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var twitterJSONResponse = response.getJsonPayload();
                                    match twitterJSONResponse {
                                        mime:EntityError err => {
                                            twitterError.errorMessage = err.message;
                                            return twitterError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                trends = convertTrends(jsonResponse);
                                                return trends;
                                            } else {
                                                twitterError.errorMessage = jsonResponse.errors[0].message.toString()
                                                                            but { () => "" };
                                                twitterError.statusCode = statusCode;
                                                return twitterError;
                                            }
                                        }
                                    }
        }
    }
}
