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

import ballerina/http;

@Description {value:"Set the client configuration."}
public function <TwitterConfiguration twitterConfig> TwitterConfiguration () {
    twitterConfig.clientConfig = {};
}

@Description {value: "Twitter connector endpoint initialization function"}
@Param {value: "TwitterConfiguration: Twitter connector configuration"}
public function TwitterClient::init (TwitterConfiguration twitterConfig) {
    twitterConfig.uri = "https://api.twitter.com";
    twitterConnector.accessToken = twitterConfig.accessToken;
    twitterConnector.accessTokenSecret = twitterConfig.accessTokenSecret;
    twitterConnector.clientId = twitterConfig.clientId;
    twitterConnector.clientSecret = twitterConfig.clientSecret;
    twitterConfig.clientConfig.targets = [{url:twitterConfig.uri}];
    twitterConnector.clientEndpoint.init(twitterConfig.clientConfig);
}

@Description {value: "Register Twitter connector endpoint"}
@Param {value: "typedesc: Accepts types of data (int, float, string, boolean, etc)"}
public function TwitterClient::register(typedesc serviceType) {}

@Description {value: "Start Twitter connector endpoint"}
public function TwitterClient::start() {}

@Description {value:"Returns the connector that client code uses."}
@Return {value:"The connector that client code uses."}
public function TwitterClient::getClient() returns TwitterConnector {
    return twitterConnector;
}

@Description {value:"Stops the registered service"}
public function TwitterClient::stop() {}
