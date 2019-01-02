[![Build Status](https://travis-ci.org/wso2-ballerina/module-twitter.svg?branch=master)](https://travis-ci.org/wso2-ballerina/module-twitter)

# Ballerina Twitter Connector

The Twitter connector allows you to tweet, retweet, untweet, and search for tweets through the Twitter REST API.
It handles OAuth 2.0 authentication. You can also retrieve and destroy a status, retrieve closest trend locations,
and top trends using the connector.

## Compatibility
| Ballerina Language Version | Twitter API version  |
| -------------------------- | -------------------- |
| 0.990.0                    | 1.1                  |


The following sections provide you with information on how to use the Ballerina Twitter connector.

- [Contribute To Develop](#contribute-to-develop)
- [Working with Twitter Connector actions](#working-with-twitter-connector-actions)
- [Example](#example)

### Contribute To develop

Clone the repository by running the following command 
```shell
git clone https://github.com/wso2-ballerina/module-twitter.git
```

### Working with Twitter Connector actions

All the actions return valid response or error. If the action is a success, then the requested resource will 
be returned. Else error will be returned.

In order for you to use the Twitter Connector, first you need to create a Twitter Client endpoint.

```ballerina
twitter:TwitterConfiguration twitterConfig = {
    clientId: testClientId,
    clientSecret: testClientSecret,
    accessToken: testAccessToken,
    accessTokenSecret: testAccessTokenSecret
};

twitter:Client twitterClient = new(twitterConfig);
```

##### Example

```ballerina
import ballerina/io;
import wso2/twitter;

public function main() {
    twitter:Client twitterClient = new({
        clientId: "",
        clientSecret: "",
        accessToken: "",
        accessTokenSecret: ""
    });

    string status = "Twitter endpoint test";

    twitter:Status|error result = twitterClient->tweet(status);
    if (result is twitter:Status) {    
        io:println("Tweet ID: ", result.id);
        io:println("Tweet: ", result.text);
    } else {
        io:println("Error occurred on tweet attempt: ", result);
    }
}
```
