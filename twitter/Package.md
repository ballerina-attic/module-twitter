# Ballerina Twitter Connector

Connects to Twitter from Ballerina..

Twitter connector provides a Ballerina API to access the Twitter REST API. This connector provides facility to update the current status, 
retweet a tweet, untweet a retweeted status, search for tweets, retrive a status, distroy a status, 
retrive closest trend locations and retrive top trends by place. The following section provide you the details on how to use Ballerina Twitter connector.


## Compatibility
| Ballerina Language Version | Twitter API version  |
| ------------- | ----- |
| 0.970.0-beta13 | 1.1 |


## Getting started
1. To download and install Ballerina, see the [Getting Started guide](https://ballerina.io/learn/getting-started/) guide.

2. Obtain your Twitter credentials. To access Twitter, you will need to provide the Consumer Key (API Key), Consumer Secret (API Secret), 
   Access Token, Access Token Secret. Create a twitter app by visiting [https://apps.twitter.com/](https://apps.twitter.com/).
   
3. Create a new Ballerina project by executing the following command.
    ```shell
       $ ballerina init
    ```
4. Import the twitter package to your Ballerina program as follows.

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
    
        twitter:Status twitterStatus = check twitterClient->tweet(status, "", "");
        string tweetId = <string> twitterStatus.id;
        string text = twitterStatus.text;
        io:println("Tweet ID: " + tweetId);
        io:println("Tweet: " + text);
    }
    ```
    
## Next Step
For detailed information on functions available in this connector, see [Twitter Connector Reference](https://docs.central.ballerina.io/wso2/twitter/0.9.13)