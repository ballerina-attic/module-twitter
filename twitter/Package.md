# Ballerina Twitter Connector

Allows you to access the Twitter REST API.

Twitter connector provides a Ballerina API to access the Twitter REST API. This connector provides facility to update the current status, 
retweet a tweet, untweet a retweeted status, search for tweets, retrive a status, distroy a status, 
retrive closest trend locations and retrive top trends by place. The following section provide you the details on how to use Ballerina Twitter connector.


## Compatibility
| Ballerina Language Version | Twitter API version  |
|: ------------- :|: ----- :|
| 0.970.0-beta12 | 1.1 |


## Getting started
1. Refer the [Getting Started guide](https://ballerina.io/learn/getting-started/) to download Ballerina and install tools.

2. Create a twitter app by visiting [https://apps.twitter.com/](https://apps.twitter.com/)
3. To use Twitter connector, you need to provide the following :
    * Consumer Key (API Key)
    * Consumer Secret (API Secret)
    * Access Token
    * Access Token Secret
    
    **IMPORTANT:** This access token can be used to make API requests on your own account's behalf. Do not share your access token secret with anyone.
4. Create a new Ballerina project by executing the following command.
    ```ballerina
    <PROJECT_ROOT_DIRECTORY>$ ballerina init
    ```
5. Import the twitter package to your Ballerina program as follows.

    ```ballerina
    import ballerina/io;
    import wso2/twitter;
    
    function main(string... args) {
        endpoint twitter:Client twitterClient {
            clientId:"<your_clientId>",
            clientSecret:"<your_clientSecret>",
            accessToken:"<your_access_token>",
            accessTokenSecret:"<your_access_token_secret>",
            clientConfig:{}
        };
        string status = "Twitter connector test";
    
        twitter:Status twitterStatus = check twitterClient -> tweet(status, "", "");
        string tweetId = <string> twitterStatus.id;
        string text = twitterStatus.text;
        io:println("Tweet ID: " + tweetId);
        io:println("Tweet: " + text);
    }
    ```