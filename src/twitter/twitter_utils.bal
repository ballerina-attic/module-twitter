import ballerina/crypto;
import ballerina/encoding;
import ballerina/lang.'string as strings;
import ballerina/log;
import ballerina/system;
import ballerina/time;

function generateAuthorizationHeader(TwitterCredential twitterCredential, string httpMethod, string serviceEP,
                                     string? urlParams = ()) returns string|error {
    string nonce = system:uuid();
    int timeInSeconds = time:currentTime().time / 1000;
    string timeStamp = timeInSeconds.toString();

    string requestParams = "oauth_consumer_key=" + twitterCredential.consumerKey + "&oauth_nonce=" + nonce +
                                "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" + timeStamp + "&oauth_token=" +
                                twitterCredential.accessToken + "&oauth_version=1.0";

    if (urlParams is string) {
        int comparision = strings:codePointCompare(requestParams, urlParams);
        match (comparision) {
            -1 => {
                requestParams += "&" + urlParams;
            }
            _ => {
                requestParams = urlParams + "&" + requestParams;
            }
        }
    }
    string encodedRequestParams = check encoding:encodeUriComponent(requestParams, UTF_8);
    string encodedServiceEP = check encoding:encodeUriComponent(TWITTER_API_URL + serviceEP, UTF_8);
    string encodedConsumerSecret = check encoding:encodeUriComponent(twitterCredential.consumerSecret, UTF_8);
    string encodedAccessTokenSecret = check encoding:encodeUriComponent(twitterCredential.accessTokenSecret, UTF_8);

    string baseString = httpMethod + "&" + encodedServiceEP + "&" + encodedRequestParams;
    string key = encodedConsumerSecret + "&" + encodedAccessTokenSecret;

    string signature = crypto:hmacSha1(baseString.toBytes(), key.toBytes()).toBase64();

    string encodedSignature = check encoding:encodeUriComponent(signature, UTF_8);
    string encodedaccessToken = check encoding:encodeUriComponent(twitterCredential.accessToken, UTF_8);

    string header = "OAuth oauth_consumer_key=\"" + twitterCredential.consumerKey +
                    "\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"" + timeStamp +
                    "\",oauth_nonce=\"" + nonce + "\",oauth_version=\"1.0\",oauth_signature=\"" + encodedSignature +
                    "\",oauth_token=\"" + encodedaccessToken + "\"";
    return header;
}

function prepareErrorResponse(json response) returns error {
    json|error errors = response.errors;
    if (errors is json[]) {
        return prepareError(errors[0].message.toString());
    } else if (errors is json) {
        return prepareError(errors.message.toString());
    } else {
        return prepareError("Error occurred while accessing the JSON payload of the error response.");
    }
}

function prepareError(string message) returns error {
    log:printError(message);
    error twitterError = error(TWITTER_ERROR_CODE, message = message);
    return twitterError;
}
