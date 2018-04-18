# Ballerina Twitter Endpoint

The Twitter endpoint allows you to access the Twitter REST API through ballerina. The following section provide you the details on how to use Ballerina 
Twitter endpoint.

## Compatibility
| Language Version        | Endpoint Version          | Twitter API version  |
| ------------- |:-------------:| -----:|
| 0.970.0-beta1-SNAPSHOT | 0.9.6 | 1.1 |


>> **Note :** The source code of the Twitter endpoint can be found at [package-twitter](https://github.com/wso2-ballerina/package-twitter)


The following sections provide you with information on how to use the Ballerina Twitter endpoint.

- [Getting started](#getting-started)
- [Quick Testing](#quick-testing)

### Getting started

1. Create a twitter app by visiting [https://apps.twitter.com/](https://apps.twitter.com/)
2. Obtain the following parameters:
    * Consumer Key (API Key)
    * Consumer Secret (API Secret)
    * Access Token
    * Access Token Secret
    
    **IMPORTANT:** This access token can be used to make API requests on your own account's behalf. Do not share your access token secret with anyone.
3. Import the package to your ballerina project.
    ```ballerina
       import wso2/twitter;
    ```
    This will download the twitter artifacts from Ballerina central repository to your local repository.


### Quick Testing

1. Create a Twitter endpoint.

```ballerina
   endpoint twitter:Client twitterEP {
       clientId:"your_clientId",
       clientSecret:"your_clientSecret",
       accessToken:"your_access_token",
       accessTokenSecret:"your_access_token_secret",
       clientConfig:{}
   };
```

2. Update current status.

```ballerina
    twitter:Status twitterStatus = check twitterClient -> tweet(status, "984337514692427776", "");
    tweetId = <string> twitterStatus.id;
    string text = twitterStatus.text;
```

3. Retrieve the collection of relevant Tweets matching a specified query.

```ballerina
    string queryStr = "twitter";
    twitter:Status[] twitterStatus = check twitterClient -> search (queryStr);
    io:println(twitterStatus.id);
```

4. Retweets a tweet.

```ballerina
    twitter:Status twitterStatus = check twitterClient -> retweet (tweetId);
    io:println(twitterStatus.retweeted);
```

5. Untweets a retweeted status.

```ballerina
    twitter:Status twitterStatus = check twitterClient -> unretweet (tweetId);
    io:println(twitterStatus.id);
```

6. Destroy the status specified by the required ID parameter.

```ballerina
    twitter:Status twitterStatus = check twitterClient -> destroyStatus (tweetId);
    io:println(twitterStatus.id);
```

7. Retrive a single status.

```ballerina
    twitter:Status twitterStatus = check twitterClient -> showStatus (tweetId);
    io:println(twitterStatus.id);
```

8. Retrieve the locations that Twitter has trending topic information.

```ballerina
    string latitude = "34";
    string longitude = "67";
    twitter:Location[] tweetResponse = check twitterClient -> getClosestTrendLocations (latitude, longitude);
    io:println(tweetResponse);
```

9. Retrieve the top topics for a specified location.

```ballerina
    string locationId = "23424922";
    twitter:Trends[] tweetResponse = check twitterClient -> getTopTrendsByPlace (locationId);
    io:println(tweetResponse);
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

    twitter:Status twitterStatus = check twitterClient -> tweet(status, "", "");
    string tweetId = <string> twitterStatus.id;
    string text = twitterStatus.text;
    io:println("Tweet ID: " + tweetId);
    io:println("Tweet: " + text);
}
```