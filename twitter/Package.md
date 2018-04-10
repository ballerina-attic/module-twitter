# Ballerina Twitter Connector

The Twitter connector allows you to access the Twitter REST API through ballerina. And the Twitter connector actions 
are being invoked with a ballerina main function. The following section provide you the details on how to use Ballerina 
Twitter connector.

## Compatibility
| Language Version        | Connector Version          | Twitter API version  |
| ------------- |:-------------:| -----:|
| ballerina-tools-0.970.0-alpha3-SNAPSHOT | 0.6 | 1.1 |


The following sections provide you with information on how to use the Ballerina Twitter connector.

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
3. Clone the repository by running the following command
    
    `git clone https://github.com/wso2-ballerina/package-twitter`
4. Import the package to your ballerina project.


### Quick Testing

1. Create a Twitter endpoint.

```ballerina
   endpoint twitter:TwitterClient twitterEP {
       clientId:"your_clientId",
       clientSecret:"your_clientSecret",
       accessToken:"your_access_token",
       accessTokenSecret:"your_access_token_secret",
       clientConfig:{}
   };
```

2. Update current status.

```ballerina
    var tweetResponse = twitterEP -> tweet(status);
    match tweetResponse {
        twitter:Status twitterStatus => {
            tweetId = <string> twitterStatus.id;
        }
        twitter:TwitterError err => {
            io:println(err.errorMessage);
        }
    }
```

3. Retrieve the collection of relevant Tweets matching a specified query.

```ballerina
    var tweetResponse = twitterEP -> search (queryStr);
    match tweetResponse {
        twitter:Status[] twitterStatus => {
            io:println(twitterStatus.id);
        }
        twitter:TwitterError err => {
            io:println(err.errorMessage);
        }
    }
```

4. Retweets a tweet.

```ballerina
    var tweetResponse = twitterEP -> retweet (tweetId);
    match tweetResponse {
        twitter:Status twitterStatus => {
            io:println(twitterStatus.retweeted);
        }
        twitter:TwitterError err => {
            io:println(err.errorMessage);
        }
    }
```

5. Untweets a retweeted status.

```ballerina
    var tweetResponse = twitterEP -> unretweet (tweetId);
    match tweetResponse {
        twitter:Status twitterStatus => {
            io:println(twitterStatus.id);
        }
        twitter:TwitterError err => {
            io:println(err.errorMessage);
        }
    }
```

6. Destroy the status specified by the required ID parameter.

```ballerina
    var tweetResponse = twitterEP -> showStatus (tweetId);
    match tweetResponse {
        twitter:Status twitterStatus => {
            io:println(twitterStatus.id);
        }
        twitter:TwitterError err => {
            io:println(err.errorMessage);
        }
    }
```

7. Retrieve the locations that Twitter has trending topic information.

```ballerina
    var tweetResponse = twitterEP -> getClosestTrendLocations (latitude, longitude);
    match tweetResponse {
        twitter:Location [] response => {
            io:println(response);
        }
        twitter:TwitterError err => {
            io:println(err.errorMessage);
        }
    }
```

8. Retrieve the top topics for a specified location.

```ballerina
    var tweetResponse = twitterEP -> getTopTrendsByPlace (locationId);
    match tweetResponse {
        twitter:Trends[] response => {
            io:println(response);
        }
        twitter:TwitterError err => {
            io:println(err.errorMessage);
        }
    }
```
