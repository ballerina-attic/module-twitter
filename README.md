# Ballerina Twitter Connector

The Twitter connector allows you to access the Twitter REST API through ballerina. And the Twitter connector actions 
are being invoked with a ballerina main function. The following section provide you the details on how to use Ballerina 
Twitter connector.

##### Prerequisites
1. Create a twitter app by visiting [https://apps.twitter.com/](https://apps.twitter.com/)
2. Obtain the following parameters:
    * Consumer Key (API Key)
    * Consumer Secret (API Secret)
    * Access Token
    * Access Token Secret

**IMPORTANT:** This access token can be used to make API requests on your own account's behalf. Do not share your access token secret with anyone.

## Working with Twitter connector actions

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


## Running samples

##### Invoke the connector methods

- Run the following commands to execute the relevant Twitter connector methods.

  1. **tweet:**
  
  `ballerina run tests/ tweet <consumerKey> <consumerSecret> <accessToken> <accessTokenSecret> <status>`
  
  2. **search:**
  
  `ballerina run tests/ search <consumerKey> <consumerSecret> <accessToken> <accessTokenSecret> <query>`
  
  3. **retweet:** 
  
  `ballerina run tests/ retweet <consumerKey> <consumerSecret> <accessToken> <accessTokenSecret> <id>`
  
  4. **unretweet:** 
  
  `ballerina run tests/ unretweet <consumerKey> <consumerSecret> <accessToken> <accessTokenSecret> <id>`
  
  5. **showStatus:** 
  
  `ballerina run tests/ showStatus <consumerKey> <consumerSecret> <accessToken> <accessTokenSecret> <id>`
  
  6. **destroyStatus:**
  
  `ballerina run tests/ destroyStatus <consumerKey> <consumerSecret> <accessToken> <accessTokenSecret> <id>`
  
  7. **getClosestTrendLocations:**
  
  `ballerina run tests/ getClosestTrendLocations <consumerKey> <consumerSecret> <accessToken> <accessTokenSecret> <latitude> <longitude>`
  
  8. **getTopTrendsByPlace:**
  
  `ballerina run tests/ getTopTrendsByPlace <consumerKey> <consumerSecret> <accessToken> <accessTokenSecret> <locationId>`
  
  
  
  

| Ballerina Version | Twitter Connector Version |
| ----------------- | ---------------------- |
| 0.970.0-alpha0 | V1 |                    