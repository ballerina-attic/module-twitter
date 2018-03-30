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

import ballerina/net.http;

@Description {value:"Struct to set the twitter configuration."}
public struct TwitterConfiguration {
    string uri;
    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:ClientEndpointConfiguration clientConfig;
}

@Description {value:"Set the client configuration."}
public function <TwitterConfiguration twitterConfig> TwitterConfiguration () {
    twitterConfig.clientConfig = {};
}

@Description {value:"Twitter Endpoint struct."}
public struct TwitterEndpoint {
    TwitterConfiguration twitterConfig;
    TwitterConnector twitterConnector;
}

@Description {value:"Initialize Twitter endpoint."}
public function <TwitterEndpoint ep> init (TwitterConfiguration twitterConfig) {
    twitterConfig.uri = "https://api.twitter.com";
    httpClientGlobal = http:createHttpClient(twitterConfig.uri, twitterConfig.clientConfig);
    ep.twitterConnector = {
        accessToken:twitterConfig.accessToken,
        accessTokenSecret:twitterConfig.accessTokenSecret,
        clientId:twitterConfig.clientId,
        clientSecret:twitterConfig.clientSecret,
        httpClient:httpClientGlobal
    };
    isConnectorInitialized = true;
}

public function <TwitterConnector ep> register(typedesc serviceType) {

}

public function <TwitterConnector ep> start() {

}

@Description {value:"Returns the connector that client code uses."}
@Return {value:"The connector that client code uses."}
public function <TwitterEndpoint ep> getClient() returns TwitterConnector {
    return ep.twitterConnector;
}

@Description {value:"Stops the registered service"}
@Return {value:"Error occured during registration"}
public function <TwitterEndpoint ep> stop() {

}
