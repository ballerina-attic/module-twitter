# Ballerina Twitter Endpoint

The Twitter endpoint allows you to access the Twitter REST API through ballerina. And the Twitter endpoint actions 
are being invoked with a ballerina main function. The following section provide you the details on how to use Ballerina 
Twitter endpoint.

## Compatibility
| Language Version        | Endpoint Version          | Twitter API version  |
| ------------- |:-------------:| -----:|
| 0.970.0-beta0 | 0.9.5 | 1.1 |


The following sections provide you with information on how to use the Ballerina Twitter endpoint.

- [Getting started](#getting-started)

### Getting started

1. Create a twitter app by visiting [https://apps.twitter.com/](https://apps.twitter.com/)
2. Obtain the following parameters:
    * Consumer Key (API Key)
    * Consumer Secret (API Secret)
    * Access Token
    * Access Token Secret
    
    **IMPORTANT:** This access token can be used to make API requests on your own account's behalf. Do not share your access token secret with anyone.
3. Clone the repository by running the following command
    
    `git clone https://github.com/wso2-ballerina/package-twitter`
4. Import the package to your ballerina project.


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

    twitter:Status twitterStatus = check twitterClient -> tweet(status, "", "");
    string tweetId = <string> twitterStatus.id;
    string text = twitterStatus.text;
    io:println("Tweet ID: " + tweetId);
    io:println("Tweet: " + text);
}
```