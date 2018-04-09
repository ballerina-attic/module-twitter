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

@Description{ value : "Update the authenticated user's current status."}
@Param{ value : "status: The text of status update"}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function TwitterConnector::tweet (string status) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};

    string tweetPath = "/1.1/statuses/update.json";
    string encodedStatusValue = check http:encode(status, "UTF-8");
    string urlParams = "status=" + encodedStatusValue + "&";
    string oauthStr = constructOAuthParams(clientId, accessToken) + urlParams;

    constructRequestHeaders(request, "POST", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
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

@Description{ value : "Retweet a tweet."}
@Param{ value : "id: The numerical ID of the desired status."}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function TwitterConnector::retweet (string id) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};
    string oauthStr = constructOAuthParams(clientId, accessToken);

    string tweetPath = "/1.1/statuses/retweet/" + id + ".json";
    constructRequestHeaders(request, "POST", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
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

@Description{ value : "Untweet a retweeted status."}
@Param{ value : "id: The numerical ID of the desired status."}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function TwitterConnector::unretweet (string id) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};
    string oauthStr = constructOAuthParams(clientId, accessToken);

    string tweetPath = "/1.1/statuses/unretweet/" + id + ".json";
    constructRequestHeaders(request, "POST", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
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

@Description{ value : "Search for tweets."}
@Param{ value : "query: Query string to retrieve the related tweets."}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function TwitterConnector::search (string queryStr) returns Status[] | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = self.clientEndpoint;
    TwitterError twitterError = {};
    string tweetPath = "/1.1/search/tweets.json";
    string encodedQueryValue = check http:encode(queryStr, "UTF-8");
    string urlParams = "q=" + encodedQueryValue + "&";
    string oauthStr = constructOAuthParams(clientId, accessToken) + urlParams;

    http:Request request;
    constructRequestHeaders(request, "GET", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
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

@Description{ value : "Retrive a single status."}
@Param{ value : "id: The numerical ID of the desired status."}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function TwitterConnector::showStatus (string id) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};
    string tweetPath = "/1.1/statuses/show.json";
    string urlParams = "id=" + id;
    string oauthStr = urlParams + "&" + constructOAuthParams(clientId, accessToken);

    constructRequestHeaders(request, "GET", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
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

@Description{ value : "Distroy a status."}
@Param{ value : "id: The numerical ID of the desired status."}
@Return{ value : "Response object or Error occured during HTTP client invocation."}
public function TwitterConnector::destroyStatus (string id) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = self.clientEndpoint;
    http:Request request;
    TwitterError twitterError = {};
    string oauthStr = constructOAuthParams(clientId, accessToken);

    string tweetPath = "/1.1/statuses/destroy/" + id + ".json";
    constructRequestHeaders(request, "POST", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
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

@Description{ value : "Retrive closest trend locations."}
@Param{ value : "lat: Latitude of the location."}
@Param{ value : "long: Longitude of the location"}
@Return{ value : "Location object or Error occured during HTTP client invocation."}
public function TwitterConnector::getClosestTrendLocations (string lat, string long)
returns Location [] | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = self.clientEndpoint;
    TwitterError twitterError = {};
    string tweetPath = "/1.1/trends/closest.json";
    string urlParams =  "&lat=" + lat + "&long=" + long;
    string oauthStr = urlParams.subString(1, urlParams.length()) + "&" +
                      constructOAuthParams(clientId, accessToken);
    http:Request request;
    constructRequestHeaders(request, "GET", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
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

@Description{ value : "Retrive top trends by place."}
@Param{ value : "locationId: The Yahoo! Where On Earth ID of the location to return trending information for."}
@Return{ value : "Trends object or Error occured during HTTP client invocation."}
public function TwitterConnector::getTopTrendsByPlace (string locationId)
returns Trends[] | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = self.clientEndpoint;
    TwitterError twitterError = {};
    string tweetPath = "/1.1/trends/place.json";
    string urlParams = "id=" + locationId;
    string oauthStr = urlParams + "&" + constructOAuthParams(clientId, accessToken);

    http:Request request;
    constructRequestHeaders(request, "GET", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
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
