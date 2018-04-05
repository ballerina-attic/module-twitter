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

package twitter;

import ballerina/time;
import ballerina/util;
import ballerina/http;
import ballerina/net.uri;
import ballerina/security.crypto;
import ballerina/io;

string timeStamp;
string nonceString;

function constructOAuthParams(string consumerKey, string accessToken) returns string {
    nonceString = util:uuid();
    time:Time time = time:currentTime();
    int currentTimeMills = time.time;
    timeStamp = <string> (currentTimeMills/1000);
    string paramStr = "oauth_consumer_key=" + consumerKey + "&oauth_nonce=" + nonceString +
                      "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" + timeStamp + "&oauth_token=" + accessToken
                      + "&oauth_version=1.0&";
    return paramStr;
}

function constructRequestHeaders(http:Request request, string httpMethod, string serviceEP, string consumerKey,
                                 string consumerSecret, string accessToken, string accessTokenSecret, string paramStr) {
    int index;
    string key;
    string value;

    serviceEP = "https://api.twitter.com" + serviceEP;
    paramStr = paramStr.subString(0, paramStr.length() - 1);
    string encodedServiceEPValue =? uri:encode(serviceEP, "UTF-8");
    string encodedParamStrValue =? uri:encode(paramStr, "UTF-8");
    string encodedConsumerSecretValue =? uri:encode(consumerSecret, "UTF-8");
    string encodedAccessTokenSecretValue =? uri:encode(accessTokenSecret, "UTF-8");

    string baseString = httpMethod + "&" + encodedServiceEPValue + "&" + encodedParamStrValue;
    string keyStr =  encodedConsumerSecretValue + "&" + encodedAccessTokenSecretValue;
    string signature = util:base16ToBase64Encode(crypto:getHmac(baseString, keyStr, crypto:Algorithm.SHA1));

    string encodedSignatureValue =? uri:encode(signature, "UTF-8");
    string encodedaccessTokenValue =? uri:encode(accessToken, "UTF-8");

    string oauthHeaderString = "OAuth oauth_consumer_key=\"" + consumerKey +
                               "\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"" + timeStamp +
                               "\",oauth_nonce=\"" + nonceString + "\",oauth_version=\"1.0\",oauth_signature=\"" +
                               encodedSignatureValue + "\",oauth_token=\"" + encodedaccessTokenValue + "\"";
    request.setHeader("Authorization", oauthHeaderString.unescape());
}