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

package twitter;

import ballerina/io;
import ballerina/net.uri;
import ballerina/mime;

@Description{ value : "Update the authenticated user's current status."}
@Param{ value : "status: The text of status update"}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function <TwitterConnector twitterConnector> tweet (string status) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = twitterConnector.clientEndpoint;
    http:Request request = {};
    TwitterError twitterError = {};
    string clientId = twitterConnector.clientId;
    string clientSecret = twitterConnector.clientSecret;
    string accessToken = twitterConnector.accessToken;
    string accessTokenSecret = twitterConnector.accessTokenSecret;

    string tweetPath = "/1.1/statuses/update.json";
    string encodedStatusValue =? uri:encode(status, "UTF-8");
    string urlParams = "status=" + encodedStatusValue + "&";
    string oauthStr = constructOAuthParams(clientId, accessToken) + urlParams;

    constructRequestHeaders(request, "POST", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
    tweetPath = tweetPath + "?" + urlParams;
    Status twitterResponse = {};
    try {
        var httpResponse =? clientEndpoint -> post(tweetPath, request);
        int statusCode = httpResponse.statusCode;
        var twitterJSONResponse =? httpResponse.getJsonPayload();
        if (statusCode == 200) {
            twitterResponse = convertToStatus(twitterJSONResponse);
        } else {
            twitterError.errorMessage = twitterJSONResponse.errors[0].message.toString();
            twitterError.statusCode = statusCode;
            return twitterError;
        }
    } catch (http:HttpConnectorError err) {
        twitterError.errorMessage = err.message;
        twitterError.statusCode = err.statusCode;
        return twitterError;
    } catch (mime:EntityError err) {
        twitterError.errorMessage = err.message;
        return twitterError;
    }

    return twitterResponse;
}

@Description{ value : "Retweet a tweet."}
@Param{ value : "id: The numerical ID of the desired status."}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function <TwitterConnector twitterConnector> retweet (string id) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = twitterConnector.clientEndpoint;
    http:Request request = {};
    TwitterError twitterError = {};
    string clientId = twitterConnector.clientId;
    string clientSecret = twitterConnector.clientSecret;
    string accessToken = twitterConnector.accessToken;
    string accessTokenSecret = twitterConnector.accessTokenSecret;
    string oauthStr = constructOAuthParams(clientId, accessToken);

    string tweetPath = "/1.1/statuses/retweet/" + id + ".json";
    constructRequestHeaders(request, "POST", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
    Status twitterResponse = {};
    try {
        var httpResponse =? clientEndpoint -> post(tweetPath, request);
        int statusCode = httpResponse.statusCode;
        var twitterJSONResponse =? httpResponse.getJsonPayload();

        if (statusCode == 200) {
            twitterResponse = convertToStatus(twitterJSONResponse);
        } else {
            twitterError.errorMessage = twitterJSONResponse.errors[0].message.toString();
            twitterError.statusCode = statusCode;
            return twitterError;
        }
    } catch (http:HttpConnectorError err) {
        twitterError.errorMessage = err.message;
        twitterError.statusCode = err.statusCode;
        return twitterError;
    } catch (mime:EntityError err) {
        twitterError.errorMessage = err.message;
        return twitterError;
    }

    return twitterResponse;
}

@Description{ value : "Untweet a retweeted status."}
@Param{ value : "id: The numerical ID of the desired status."}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function <TwitterConnector twitterConnector> unretweet (string id) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = twitterConnector.clientEndpoint;
    http:Request request = {};
    TwitterError twitterError = {};
    string clientId = twitterConnector.clientId;
    string clientSecret = twitterConnector.clientSecret;
    string accessToken = twitterConnector.accessToken;
    string accessTokenSecret = twitterConnector.accessTokenSecret;
    string oauthStr = constructOAuthParams(clientId, accessToken);

    string tweetPath = "/1.1/statuses/unretweet/" + id + ".json";
    constructRequestHeaders(request, "POST", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
    Status twitterResponse = {};
    try {
        var httpResponse =? clientEndpoint -> post(tweetPath, request);
        int statusCode = httpResponse.statusCode;
        var twitterJSONResponse =? httpResponse.getJsonPayload();

        if (statusCode == 200) {
            twitterResponse = convertToStatus(twitterJSONResponse);
        } else {
            twitterError.errorMessage = twitterJSONResponse.errors[0].message.toString();
            twitterError.statusCode = statusCode;
            return twitterError;
        }
    } catch (http:HttpConnectorError err) {
        twitterError.errorMessage = err.message;
        twitterError.statusCode = err.statusCode;
        return twitterError;
    } catch (mime:EntityError err) {
        twitterError.errorMessage = err.message;
        return twitterError;
    }

    return twitterResponse;
}

@Description{ value : "Search for tweets."}
@Param{ value : "query: Query string to retrieve the related tweets."}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function <TwitterConnector twitterConnector> search (string queryStr) returns Status[] | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = twitterConnector.clientEndpoint;
    TwitterError twitterError = {};
    string clientId = twitterConnector.clientId;
    string clientSecret = twitterConnector.clientSecret;
    string accessToken = twitterConnector.accessToken;
    string accessTokenSecret = twitterConnector.accessTokenSecret;
    string tweetPath = "/1.1/search/tweets.json";
    string encodedQueryValue =? uri:encode(queryStr, "UTF-8");
    string urlParams = "q=" + encodedQueryValue + "&";
    string oauthStr = constructOAuthParams(clientId, accessToken) + urlParams;

    http:Request request = {};
    constructRequestHeaders(request, "GET", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
    tweetPath = tweetPath + "?" + urlParams;

    Status[] searchResponse = [];
    try {
        var httpResponse =? clientEndpoint -> get(tweetPath, request);
        int statusCode = httpResponse.statusCode;
        var twitterJSONResponse =? httpResponse.getJsonPayload();

        if (statusCode == 200) {
            if (twitterJSONResponse.statuses != null) {
                searchResponse = convertToStatuses(twitterJSONResponse.statuses);
            }
        } else {
            twitterError.errorMessage = twitterJSONResponse.error.message.toString();
            twitterError.statusCode = statusCode;
            return twitterError;
        }
    } catch (http:HttpConnectorError err) {
        twitterError.errorMessage = err.message;
        twitterError.statusCode = err.statusCode;
        return twitterError;
    } catch (mime:EntityError err) {
        twitterError.errorMessage = err.message;
        return twitterError;
    }

    return searchResponse;
}

@Description{ value : "Retrive a single status."}
@Param{ value : "id: The numerical ID of the desired status."}
@Return{ value : "Status object or Error occured during HTTP client invocation."}
public function <TwitterConnector twitterConnector> showStatus (string id) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = twitterConnector.clientEndpoint;
    http:Request request = {};
    TwitterError twitterError = {};
    string clientId = twitterConnector.clientId;
    string clientSecret = twitterConnector.clientSecret;
    string accessToken = twitterConnector.accessToken;
    string accessTokenSecret = twitterConnector.accessTokenSecret;
    string tweetPath = "/1.1/statuses/show.json";
    string urlParams = "id=" + id;
    string oauthStr = urlParams + "&" + constructOAuthParams(clientId, accessToken);

    constructRequestHeaders(request, "GET", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
    tweetPath = tweetPath + "?" + urlParams;
    Status twitterResponse = {};
    try {
        var httpResponse =? clientEndpoint -> get(tweetPath, request);
        int statusCode = httpResponse.statusCode;
        var twitterJSONResponse =? httpResponse.getJsonPayload();

        if (statusCode == 200) {
            twitterResponse = convertToStatus(twitterJSONResponse);
        } else {
            twitterError.errorMessage = twitterJSONResponse.errors[0].message.toString();
            twitterError.statusCode = statusCode;
            return twitterError;
        }
    } catch (http:HttpConnectorError err) {
        twitterError.errorMessage = err.message;
        twitterError.statusCode = err.statusCode;
        return twitterError;
    } catch (mime:EntityError err) {
        twitterError.errorMessage = err.message;
        return twitterError;
    }

    return twitterResponse;
}

@Description{ value : "Distroy a status."}
@Param{ value : "id: The numerical ID of the desired status."}
@Return{ value : "Response object or Error occured during HTTP client invocation."}
public function <TwitterConnector twitterConnector> destroyStatus (string id) returns Status | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = twitterConnector.clientEndpoint;
    http:Request request = {};
    TwitterError twitterError = {};
    string clientId = twitterConnector.clientId;
    string clientSecret = twitterConnector.clientSecret;
    string accessToken = twitterConnector.accessToken;
    string accessTokenSecret = twitterConnector.accessTokenSecret;
    string oauthStr = constructOAuthParams(clientId, accessToken);

    string tweetPath = "/1.1/statuses/destroy/" + id + ".json";
    constructRequestHeaders(request, "POST", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
    Status twitterResponse = {};
    try {
        var httpResponse =? clientEndpoint -> post(tweetPath, request);
        int statusCode = httpResponse.statusCode;
        var twitterJSONResponse =? httpResponse.getJsonPayload();

        if (statusCode == 200) {
            twitterResponse = convertToStatus(twitterJSONResponse);
        } else {
            twitterError.errorMessage = twitterJSONResponse.errors[0].message.toString();
            twitterError.statusCode = statusCode;
            return twitterError;
        }
    } catch (http:HttpConnectorError err) {
        twitterError.errorMessage = err.message;
        twitterError.statusCode = err.statusCode;
        return twitterError;
    } catch (mime:EntityError err) {
        twitterError.errorMessage = err.message;
        return twitterError;
    }

    return twitterResponse;
}

@Description{ value : "Retrive closest trend locations."}
@Param{ value : "lat: Latitude of the location."}
@Param{ value : "long: Longitude of the location"}
@Return{ value : "Location object or Error occured during HTTP client invocation."}
public function <TwitterConnector twitterConnector> getClosestTrendLocations (string lat, string long)
                                                                    returns Location [] | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = twitterConnector.clientEndpoint;
    TwitterError twitterError = {};
    string clientId = twitterConnector.clientId;
    string clientSecret = twitterConnector.clientSecret;
    string accessToken = twitterConnector.accessToken;
    string accessTokenSecret = twitterConnector.accessTokenSecret;
    string tweetPath = "/1.1/trends/closest.json";
    string urlParams =  "&lat=" + lat + "&long=" + long;
    string oauthStr = urlParams.subString(1, urlParams.length()) + "&" +
                      constructOAuthParams(clientId, accessToken);
    http:Request request = {};
    constructRequestHeaders(request, "GET", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
    tweetPath = tweetPath + "?" + urlParams.subString(1, urlParams.length());

    Location[] locations = [];
    try {
        var httpResponse =? clientEndpoint -> get(tweetPath, request);
        int statusCode = httpResponse.statusCode;
        var twitterJSONResponse =? httpResponse.getJsonPayload();

        if (statusCode == 200) {
            locations = convertToLocations(twitterJSONResponse);
        } else {
            twitterError.errorMessage = twitterJSONResponse.errors[0].message.toString();
            twitterError.statusCode = statusCode;
            return twitterError;
        }
    } catch (http:HttpConnectorError err) {
        twitterError.errorMessage = err.message;
        twitterError.statusCode = err.statusCode;
        return twitterError;
    } catch (mime:EntityError err) {
        twitterError.errorMessage = err.message;
        return twitterError;
    }

    return locations;
}

@Description{ value : "Retrive top trends by place."}
@Param{ value : "locationId: The Yahoo! Where On Earth ID of the location to return trending information for."}
@Return{ value : "Trends object or Error occured during HTTP client invocation."}
public function <TwitterConnector twitterConnector> getTopTrendsByPlace (string locationId)
                                                                    returns Trends[] | TwitterError {
    endpoint http:ClientEndpoint clientEndpoint = twitterConnector.clientEndpoint;
    TwitterError twitterError = {};
    string clientId = twitterConnector.clientId;
    string clientSecret = twitterConnector.clientSecret;
    string accessToken = twitterConnector.accessToken;
    string accessTokenSecret = twitterConnector.accessTokenSecret;
    string tweetPath = "/1.1/trends/place.json";
    string urlParams = "id=" + locationId;
    string oauthStr = urlParams + "&" + constructOAuthParams(clientId, accessToken);

    http:Request request = {};
    constructRequestHeaders(request, "GET", tweetPath, clientId, clientSecret, accessToken, accessTokenSecret,
                            oauthStr);
    tweetPath = tweetPath + "?" + urlParams;

    Trends[] trends = [];
    try {
        var httpResponse =? clientEndpoint -> get(tweetPath, request);
        int statusCode = httpResponse.statusCode;
        var twitterJSONResponse =? httpResponse.getJsonPayload();

        if (statusCode == 200) {
            trends = convertTrends(twitterJSONResponse);
        } else {
            twitterError.errorMessage = twitterJSONResponse.errors[0].message.toString();
            twitterError.statusCode = statusCode;
            return twitterError;
        }
    } catch (http:HttpConnectorError err) {
        twitterError.errorMessage = err.message;
        twitterError.statusCode = err.statusCode;
        return twitterError;
    } catch (mime:EntityError err) {
        twitterError.errorMessage = err.message;
        return twitterError;
    }

    return trends;
}
