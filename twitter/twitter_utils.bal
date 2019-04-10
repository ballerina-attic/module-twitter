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
import ballerina/crypto;
import ballerina/http;
import ballerina/system;
import ballerina/time;

# Construct the authorization header with the signature.
#
# + request - HTTP request.
# + httpMethod - HTTP method.
# + serviceEP - Twitter API resource endpoint.
# + consumerKey - The consumer key of the Twitter account.
# + consumerSecret - The consumer secret of the Twitter account.
# + accessToken - The access token of the Twitter account.
# + accessTokenSecret - The access token secret of the Twitter account.
# + parameters - List of URL parameters which need to be consider when generating the signature.
# + return - Returns the error object that occurred while encoding parameters.
public function constructRequestHeaders(http:Request request, string httpMethod, string serviceEP, string consumerKey,
                                 string consumerSecret, string accessToken, string accessTokenSecret,
                                 map<anydata> parameters) returns error? {

    string paramStr = "";
    int index = 0;
    string key;
    string value;
    string nonceString = system:uuid();
    time:Time time = time:currentTime();
    int currentTimeMills = time.time;
    string timeStamp = string.convert(currentTimeMills / 1000);

    string serviceEndpoint = TWITTER_API_URL + serviceEP;

    parameters["oauth_consumer_key"] = consumerKey;
    parameters["oauth_nonce"] = nonceString;
    parameters["oauth_signature_method"] = "HMAC-SHA1";
    parameters["oauth_timestamp"] = timeStamp;
    parameters["oauth_token"] = accessToken;
    parameters["oauth_version"] = "1.0";

    string[] parameterKeys = parameters.keys();
    string[] sortedParameters = sort(parameterKeys);
    while (index < sortedParameters.length()) {
        key = sortedParameters[index];
        value = <string>parameters[key];
        paramStr = paramStr + key + "=" + value + "&";
        index = index + 1;
    }

    string paramString = paramStr.substring(0, paramStr.length() - 1);
    string encodedServiceEPValue = check http:encode(serviceEndpoint, UTF_8);
    string encodedParamStrValue = check http:encode(paramString, UTF_8);
    string encodedConsumerSecretValue = check http:encode(consumerSecret, UTF_8);
    string encodedAccessTokenSecretValue = check http:encode(accessTokenSecret, UTF_8);

    string baseString = httpMethod + "&" + encodedServiceEPValue + "&" + encodedParamStrValue;
    byte[] baseStringByte = baseString.toByteArray(UTF_8);
    string keyStr = encodedConsumerSecretValue + "&" + encodedAccessTokenSecretValue;
    byte[] keyArrByte = keyStr.toByteArray(UTF_8);
    string signature = encoding:encodeBase64(crypto:hmacSha1(baseStringByte, keyArrByte));

    string encodedSignatureValue = check http:encode(signature, UTF_8);
    string encodedaccessTokenValue = check http:encode(accessToken, UTF_8);

    string oauthHeaderString = "OAuth oauth_consumer_key=\"" + consumerKey +
        "\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"" + timeStamp +
        "\",oauth_nonce=\"" + nonceString + "\",oauth_version=\"1.0\",oauth_signature=\"" +
        encodedSignatureValue + "\",oauth_token=\"" + encodedaccessTokenValue + "\"";
    request.setHeader("Authorization", oauthHeaderString.unescape());
    return ();
}

function setResponseError(json jsonResponse) returns error {
    error err = error(TWITTER_ERROR_CODE, { ^"cause": jsonResponse, message: jsonResponse.errors[0].message });
    return err;
}
