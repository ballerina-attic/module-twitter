# Ballerina Twitter Connector

The Twitter connector allows you to access the Twitter REST API through ballerina. The following section provide you the details on how to use Ballerina 
Twitter connector.

## Compatibility
| Ballerina Language Version | Twitter API version  |
| ------------- | ----- |
| 0.970.0-beta19 | 1.1 |


The following sections provide you with information on how to use the Ballerina Twitter connector.

- [Contribute To Develop](#contribute-to-develop)
- [Working with Twitter Connector actions](#working-with-twitter-endpoint-actions)
- [Example](#example)

### Contribute To develop

Clone the repository by running the following command 
```ballerina
    git clone https://github.com/wso2-ballerina/package-twitter.git
```

### Working with Twitter Connector actions

All the actions return valid response or TwitterError. If the action is a success, then the requested resource will 
be returned. Else TwitterError object will be returned.

In order for you to use the Twitter Connector, first you need to create a Twitter Client endpoint.

```ballerina
    endpoint twitter:Client twitterClient {
        clientId:"",
        clientSecret:"",
        accessToken:"",
        accessTokenSecret:"",
        clientConfig:{}
    };
```

##### Example

```ballerina
import ballerina/io;
import wso2/twitter;

public function main(string[] args) {
    endpoint twitter:Client twitterClient {
        clientId:"",
        clientSecret:"",
        accessToken:"",
        accessTokenSecret:"",
        clientConfig:{}
    };
    string status = "Twitter endpoint test";

    twitter:Status twitterStatus = check twitterClient->tweet(status, "", "");
    string tweetId = <string> twitterStatus.id;
    string text = twitterStatus.text;
    io:println("Tweet ID: " + tweetId);
    io:println("Tweet: " + text);
}
```