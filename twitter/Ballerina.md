# Ballerina Twitter Connector

The Twitter connector allows you to access the Twitter REST API through ballerina. And the Twitter connector actions 
are being invoked with a ballerina main function. The following section provide you the details on how to use Ballerina 
Twitter connector.

## Compatibility
| Language Version        | Connector Version          | Twitter API version  |
| ------------- |:-------------:| -----:|
| ballerina-0.970-alpha-1-SNAPSHOT | 0.6 | 1.1 |


The following sections provide you with information on how to use the Ballerina SonarQube connector.

- [Getting started](#getting-started)
- [Quick Testing](#quick-testing)
- [Working with Twitter connector actions](#working-with-Twitter-connector-actions)

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
   endpoint twitter:TwitterEndpoint twitterEP {
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

9. Provide values for the variables (CLIENT_ID, CLIENT_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRET) in `ballerina.conf`.

10. Run ```ballerina test tests``` from your connector directory.

### Working with Twitter connector actions

##### Update statuses
The tweet action allows to update the authenticated user's current status, also known as tweeting.

###### Properties
  * status - The text of status update.

###### Related Twitter documentation
<https://dev.twitter.com/rest/reference/post/statuses/update>

##### Search
The search action allows to retrieve the collection of relevant Tweets matching a specified query.

###### Properties
  * query - Query string to retrieve the related tweets.

###### Related Twitter documentation
<https://dev.twitter.com/rest/reference/get/search/tweets>

##### Retweet a tweet
The retweet action allows to retweets a tweet.

###### Properties
  * id - The numerical ID of the desired status.

###### Related Twitter documentation
<https://dev.twitter.com/rest/reference/post/statuses/retweet/id>

##### Untweet a retweeted status
The unretweet action allows to Untweets a retweeted status.

###### Properties
  * id - The numerical ID of the desired status.

###### Related Twitter documentation
<https://dev.twitter.com/rest/reference/post/statuses/unretweet/id>

##### Retrive a single status
The showStatus action allows to retrieve a single Tweet, specified by the id parameter.

###### Properties
  * id - The numerical ID of the desired status.

###### Related Twitter documentation
<https://dev.twitter.com/rest/reference/get/statuses/show/id>

##### Distroy a status
The destroyStatus action allows to destroy the status specified by the required ID parameter.

###### Properties
  * id - The numerical ID of the desired status.

###### Related Twitter documentation
<https://dev.twitter.com/rest/reference/post/statuses/destroy/id>

##### Retrive closest trend locations
The getClosestTrendLocations action allows to retrieve the locations that Twitter has trending topic information
for, closest to a specified location.

###### Properties
  * lat -  If specified with the long property, the available trend location will be sorted by distance, nearest
                to furthest to the coordinate pair. The valid range for latitude is -180.0 to +180.0 (West is negative,
                East is positive) inclusive.
  * long - If specified with the lat property the available trend location will be sorted by distance, nearest to
                furthest, to the co-ordinate pair. The valid range for longitude is -180.0 to +180.0 (West is negative,
                East is positive) inclusive.

###### Related Twitter documentation
<https://dev.twitter.com/rest/reference/get/trends/closest>

##### Retrive top trends by place
The getTopTrendsByPlace action allows to retrieve the top topics for a specified location.

###### Properties
  * locationId -  The Yahoo! Where On Earth ID of the location to return trending information for.

###### Related Twitter documentation
<https://dev.twitter.com/rest/reference/get/trends/place>
