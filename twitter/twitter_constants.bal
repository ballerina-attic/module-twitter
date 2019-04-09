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

// Twitter API endpoints
const string TWITTER_API_URL = "https://api.twitter.com";
const string UPDATE_ENDPOINT = "/1.1/statuses/update.json";
const string RETWEET_ENDPOINT = "/1.1/statuses/retweet/";
const string UN_RETWEET_ENDPOINT = "/1.1/statuses/unretweet/";
const string SEARCH_ENDPOINT = "/1.1/search/tweets.json";
const string SHOW_STATUS_ENDPOINT = "/1.1/statuses/show.json";
const string DESTROY_STATUS_ENDPOINT = "/1.1/statuses/destroy/";
const string TRENDS_ENDPOINT = "/1.1/trends/closest.json";
const string TRENDS_PLACE_ENDPOINT = "/1.1/trends/place.json";
const string FAVORITE_ENDPOINT = "/1.1/favorites/create.json";
const string FOLLOWERS_ENDPOINT = "/1.1/followers/list.json";
const string HOME_TIMELINE_ENDPOINT = "/1.1/statuses/home_timeline.json";
const string MENTIONS_ENDPOINT = "/1.1/statuses/mentions_timeline.json";
const string FILTER_ENDPOINT = "/1.1/statuses/filter.json";
const string VERIFY_CREDENTIALS_ENDPOINT = "/1.1/account/verify_credentials.json";

// String constants
const string UTF_8 = "UTF-8";
const string POST = "POST";
const string GET = "GET";
const string JSON = ".json";

// Error Codes
const string TWITTER_ERROR_CODE = "(wso2/twitter)TwitterError";
const string ENCODING_ERROR_CODE = "(wso2/twitter)EncodingError";
const string IO_ERROR_CODE = "(wso2/twitter)IOError";
const string CONVERSION_ERROR_CODE = "(wso2/twitter)ConversionError";
