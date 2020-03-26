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
    # + return - If success, returns `twitter:Status` object, else returns `error`
    public remote function tweet(string status) returns @tainted Status|error {
        var encodedStatus = encoding:encodeUriComponent(status, UTF_8);
        if (encodedStatus is error) {
            return prepareError("Error occurred while encoding the status.");
        }
        string urlParams = "status=" + <string>encodedStatus;

        var header = generateAuthorizationHeader(self.twitterCredential, POST, UPDATE_API, urlParams);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }
        http:Request request = new;
        request.setHeader("Authorization", <string>header);
        string requestPath = UPDATE_API + "?" + urlParams;

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

    # Retweets a tweet, specified by the id parameter. Returns the original Tweet with Retweet details embedded.
    #
    # + id - The numerical ID of the desired status
    # + return - If success, returns `twitter:Status` object, else returns `error`
    public remote function retweet(int id) returns @tainted Status|error {
        string requestPath = RETWEET_API + id.toString() + ".json";
        var header = generateAuthorizationHeader(self.twitterCredential, POST, requestPath);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }
        http:Request request = new;
        request.setHeader("Authorization", <string>header);

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

    # Untweets a retweeted status, specified by the id parameter.
    # Returns the original Tweet, with Retweet details embedded.
    #
    # + id - The numerical ID of the desired status
    # + return - If success, returns `twitter:Status` object, else returns `error`
    public remote function unretweet(int id) returns @tainted Status|error {
        string requestPath = UN_RETWEET_API + id.toString() + ".json";
        var header = generateAuthorizationHeader(self.twitterCredential, POST, requestPath);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }
        http:Request request = new;
        request.setHeader("Authorization", <string>header);

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

    # Returns a collection of relevant Tweets matching a specified query.
    #
    # + query - Query string of 500 characters maximum, including operators
    # + advancedSearch - Optional params that is needed for advanced search operations
    # + return - If success, `twitter:Status[]` object, else returns `error`
    public remote function search(string query, AdvancedSearch? advancedSearch = ()) returns @tainted Status[]|error {
        // TODO: Implement SearchRequest optional parameters
        var encodedQuery = encoding:encodeUriComponent(query, UTF_8);
        if (encodedQuery is error) {
            return prepareError("Error occurred while encoding the query.");
        }
        string urlParams = "q=" + <string>encodedQuery;

        var header = generateAuthorizationHeader(self.twitterCredential, GET, SEARCH_API, urlParams);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }
        http:Request request = new;
        request.setHeader("Authorization", <string>header);
        string requestPath = SEARCH_API + "?" + urlParams;

        var httpResponse = self.twitterClient->get(requestPath, request);
        if (httpResponse is http:Response) {
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                int statusCode = httpResponse.statusCode;
                if (statusCode == http:STATUS_OK) {
                    return convertToStatuses(<json[]>jsonPayload.statuses);
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

    # Returns a single Tweet, specified by the id parameter. The Tweet's author will also be embedded within the Tweet.
    #
    # + id - The numerical ID of the desired status
    # + return - If success, returns `twitter:Status` object, else returns `error`
    public remote function getTweet(int id) returns @tainted Status|error {
        string urlParams = "id=" + id.toString();

        var header = generateAuthorizationHeader(self.twitterCredential, GET, SHOW_STATUS_API, urlParams);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }
        http:Request request = new;
        request.setHeader("Authorization", <string>header);
        string requestPath = SHOW_STATUS_API + "?" + urlParams;

        var httpResponse = self.twitterClient->get(requestPath, request);
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

    # Destroys the status. The authenticating user must be the author of the specified status.
    # Returns the destroyed status; if successful.
    #
    # + id - The numerical ID of the desired status
    # + return - If success, returns `twitter:Status` object, else returns `error`
    public remote function deleteTweet(int id) returns @tainted Status|error {
        string requestPath = DESTROY_STATUS_API + id.toString() + ".json";
        var header = generateAuthorizationHeader(self.twitterCredential, POST, requestPath);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }
        http:Request request = new;
        request.setHeader("Authorization", <string>header);

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
