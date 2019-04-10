Connects to Twitter from Ballerina. 

# Module Overview

The Twitter client allows you to create Tweets, reply to a Tweet, Retweets, Likes a Tweet, search Tweets, retrieve home timeline Tweets,
and retrieve mentions for the user through the Twitter REST API. You can also retrieve followers for the specified user, retrieve closest trend locations, and top trends using this twitter client.

**Tweet Operations**

The `wso2/twitter` module contains operations that work with Tweets:

* `tweet` - Update the authenticating user's current status, also known as Tweeting.
* `replyToTweet` - Reply to an existing Tweet.
* `retweet` - Retweets a tweet.
* `createFavoriteTweet` - Favorites (likes) the Tweet.
* `search` - Search a collection of relevant Tweets matching a specified query.
* `getHomeTimelineTweets` - Retrieve a collection of the most recent Tweets and Retweets posted by the authenticating user and the users they follow.
* `getTweetMentions` - Retrieve most recent mentions for the authenticating user.


**User Operations**

The `wso2/twitter` module contains operations that work with Users:

* `getFollowers` -  Retrieve followers for the specified user.


**Trends Operations**

The `wso2/twitter` module contains operations that work with Trends:

* `getTrendsByPlace` - Retrieve trending topics for a specific WOEID.
* `getClosestTrendLocations` - Retrieve the locations that Twitter has trending topic information for, closest to a specified location.


## Compatibility
|                    |    Version     |  
|:------------------:|:--------------:|
| Twitter API        |   1.1          |


## Running Sample

Let's get started with a simple program in Ballerina to send a Tweet.

Use the following command to search for modules where the module name, description, or org name contains the word "twitter".

```ballerina
$ ballerina search twitter
```

This results in a list of available modules. You can pull the one you want from Ballerina Central.

```ballerina
$ ballerina pull wso2/twitter
```

You can use the `wso2/twitter` module to integrate with Twitter back-end. Import the `wso2/twitter` module into the Ballerina project.

```ballerina
import wso2/twitter;
```

Now you can use Ballerina to integrate with Twitter.

#### Before you Begin

You need to create a Twitter app and get credentials such as Consumer Key (API Key), Consumer Secret (API Secret), Access Token, and Access Token Secret from Twitter.

**Obtaining API Keys and Tokens**

1. Visit https://apps.twitter.com/app/new and log in.
2. Provide the required information about the application.
3. Agree to the Developer Agreement and click **Create your Twitter application**.
4. After creating your Twitter application, your Consumer Key and Consumer Secret will be displayed in the Keys and Access Tokens tab of your app on Twitter.
5. Click the **Keys and Access Tokens** tab, and then enable your Twitter account to use this application by clicking the **Create my access token** button.
6. Copy the Consumer key (API key), Consumer Secret, Access Token, and Access Token Secret from the screen.


In the directory where you have your sample, create a `ballerina.conf` file and add the details you obtained above within the quotes.

```ballerina
# Ballerina config file
consumerKey = ""
consumerSecret = ""
accessToken = ""
accessTokenSecret = ""
```

#### Ballerina Program to Send a Tweet

Create a file called `twitter_sample.bal` and import the `ballerina/config` module.

```ballerina
import ballerina/config;
```

Add this code after the import statement to create base/parent Twitter client.

```ballerina

TwitterConfiguration twitterConfig = {
    clientId: config:getAsString("consumerKey"),
    clientSecret: config:getAsString("consumerSecret"),
    accessToken: config:getAsString("accessToken"),
    accessTokenSecret: config:getAsString("accessTokenSecret")
};

twitter:TwitterClient|error twitterClient = new(twitterConfig);
```

Here, we are creating an client object to connect with the Twitter service. The above configuration is used to configure the connectivity to the Twitter service.

Now, you can get the response from Twitter by calling the `tweet` remote function. Here, the `tweet` remote function updates the current status of the authenticated user and the `status` is the text message of the status update.

```ballerina
string status = "This is a sample tweet";
// Invoke tweet remote function using base/parent Twitter client.
twitter:Tweet|error tweetResponse = twitterClient->tweet(status);
```

If the status was updated successfully, the response from the `tweet` function is a `Tweet` object with the ID of the status, created time of status, etc. If the status update was unsuccessful, the response is an `error`.

The completed source code will look similar to the following:

```ballerina
import wso2/twitter;
import ballerina/config;
import ballerina/io;

TwitterConfiguration twitterConfig = {
    clientId: config:getAsString("consumerKey"),
    clientSecret: config:getAsString("consumerSecret"),
    accessToken: config:getAsString("accessToken"),
    accessTokenSecret: config:getAsString("accessTokenSecret")
};

public function main() {
   twitter:TwitterClient|error twitterClient = new(twitterConfig);

   if (twitterClient is twitter:TwitterClient) {
       string status = "This is a sample tweet";
       twitter:Tweet|error tweetResponse = twitterClient->tweet(status);
       if (tweetResponse is twitter:Tweet) {
           // If successful, print the tweet ID and text.
           io:println("Tweet ID: ", tweetResponse.id);
           io:println("Tweet: ", tweetResponse.text);
       } else {
           // If unsuccessful, print the error returned.
           io:println("Error: ", tweetResponse);
       }
   } else {
       io:println("Error: ", twitterClient);
   }
}
```

Now you can run the sample using the following command:

```ballerina
$ ballerina run twitter_sample.bal --config ballerina.conf
```


## Working with other Twitter client remote functions

**retweet**

The `retweet` remote function retweets a tweet message. It returns a `Tweet` object if successful or an `error` if unsuccessful.

```ballerina
int tweetId = 1093833789346861057;
// Invoke retweet remote function using base/parent Twitter client.
var tweetResponse = twitterClient->retweet(tweetId, trimUser = false);
if (tweetResponse is twitter:Tweet) {
    io:println("Retweeted: ", tweetResponse.retweeted);
} else {
    io:println("Error: ", tweetResponse);
}
```

**replyToTweet**

The `replyToTweet` remote function allow you to reply to an existing Tweet. It returns a `Tweet` object if successful or an `error` if unsuccessful.

```ballerina
string status = "Sample Tweet Reply";
StatusReplyParams replyParams = {
    inReplyToStatusId: 1093833789346861057,
    autoPopulateReplyMetadata: true,
    excludeReplyUserIds: "4269258922"
};
// Invoke replyToTweet remote function using base/parent Twitter client.
var replyResponse = twitterClient->replyToTweet(status, replyParams);
if (replyResponse is twitter:Tweet) {
    io:println("Tweet: ", replyResponse.text);
} else {
    io:println("Error: ", replyResponse);
}
```

**search**

The `search` remote function searches for tweets using a query string. It returns a `Search` object if successful or an `error` if unsuccessful.

```ballerina
string queryStr = "twitter";

// Invoke search remote function using base/parent Twitter client.
var searchResponse = twitterClient->search(queryStr, count = 100);
if (searchResponse is twitter:Search) {
    io:println("Search Result: ", searchResponse);
} else {
    io:println("Error: ", searchResponse);
}
```

**getFollowers**

The `getFollowers` remote function retrieve a collection of user objects for users following the specified user. It returns a `Followers` object if successful or an `error` if unsuccessful.

You can use one of the following samples to invoke `getFollowers` remote function:

1. Get the sub client of User from the base/parent Twitter client to invoke user related functions.

    ```ballerina
    // Get the `TwitterUserClient` object from the base/parent Twitter client.
    twitter:TwitterUserClient? twitterUserClient = twitterClient.getUserClient();

    if (twitterUserClient is twitter:TwitterUserClient) {
        var followersResponse = twitterUserClient->getFollowers(screenName = "WSO2", cursor = -1, count = 10,
                skipStatus = true, includeUserEntities = false);

        if (followersResponse is twitter:Followers) {
            io:println("Followers: ", followersResponse.users);
        } else {
            io:println("Error: ", followersResponse);
        }
    }
    ```

2. Create a new `TwitterUserClient` object using the `twitterConfig` to invoke user related functions.

    ```ballerina
    // Create a new User client using `twitterConfig`.
    twitter:TwitterUserClient|error twitterUserClientWithConfig = new(twitterConfig);

    if (twitterUserClientWithConfig is twitter:TwitterUserClient) {
        var followersResponse = twitterUserClientWithConfig->getFollowers(screenName = "WSO2", cursor = -1, count = 10,
                        skipStatus = true, includeUserEntities = false);

        if (followersResponse is twitter:Followers) {
            io:println("Followers: ", followersResponse.users);
        } else {
            io:println("Error: ", followersResponse);
        }
    } else {
        io:println("Error: ", twitterUserClientWithConfig);
    }
    ```

3. Get the `TwitterClient` object from `TwitterTrendsClient` and then invoke User related functions: If you have already created `TwitterTrendsClient`
   object and want to invoke User related functions, you can get the `TwitterClient` object from `TwitterTrendsClient` and then can invoke User related functions.

   ```ballerina
    // Create new Trends client using `twitterConfig`.
    twitter:TwitterTrendsClient|error twitterTrendsClient = new(twitterConfig);
    if (twitterTrendsClient is twitter:TwitterTrendsClient) {
        // Get the TwitterClient object from TwitterTrendsClient.
        twitter:TwitterClient? twitterClient = twitterTrendsClient.getTwitterClient();
        if (twitterClient is twitter:TwitterClient) {
            twitter:TwitterUserClient|error twitterUserClient = new(twitterClient);

            if (twitterUserClient is twitter:TwitterUserClient) {
                var followersResponse = twitterUserClient->getFollowers(screenName = "WSO2", cursor = -1, count = 10,
                        skipStatus = true, includeUserEntities = false);

                if (followersResponse is twitter:Followers) {
                    io:println("Followers: ", followersResponse.users);
                } else {
                    io:println("Error: ", followersResponse);
                }
            } else {
                io:println("Error: ", twitterUserClient);
            }
        }
    } else {
        io:println("Error: ", twitterTrendsClient);
    }
   ```

**getTrendsByPlace**

The `getTrendsByPlace` remote function allows to retrieve trending topics for a specific WOEID.

You can use one of the following samples to invoke `getTrendsByPlace` remote function:

1. Get the sub client of Trends from the base/parent Twitter client to invoke trend related functions.

    ```ballerina
    // Get the Trends client from the base/parent Twitter client.
    twitter:TwitterTrendsClient? twitterTrendsClient = twitterClient.getTrendsClient();
    int locationId = 23424922;
    if (twitterTrendsClient is twitter:TwitterTrendsClient) {
        var trendsResponse = twitterTrendsClient->getTrendsByPlace(locationId);
        if (trendsResponse is twitter:TrendsList[]) {
           io:println("Trends: ", trendsResponse);
        } else {
           io:println("Error: ", trendsResponse);
        }
    }
    ```

2. Create a new Trends client using the `twitterConfig` to invoke trends related functions.

    ```ballerina
    // Create new Trends client using `twitterConfig`.
    twitter:TwitterTrendsClient|error twitterTrendsClientWithConfig = new(twitterConfig);
    if (twitterTrendsClientWithConfig is twitter:TwitterTrendsClient) {
        int locationId = 23424922;
        var trendsResponse = twitterTrendsClientWithConfig->getTrendsByPlace(locationId);
        if (trendsResponse is twitter:TrendsList[]) {
           io:println("Trends: ", trendsResponse);
        } else {
           io:println("Error: ", trendsResponse);
        }
    } else {
        io:println("Error: ", twitterTrendsClientWithConfig);
    }
    ```

3. Get the `TwitterClient` object from `TwitterUserClient` and then invoke Trends related functions: If you have already created `TwitterUserClient`
      object and want to invoke Trends related functions, you can get the `TwitterClient` object from `TwitterUserClient` and then can invoke Trends related functions.

    ```ballerina
    // Create new User client using `twitterConfig`.
    twitter:TwitterUserClient|error twitterUserClient = new(twitterConfig);
    if (twitterUserClient is twitter:TwitterUserClient) {
        // Get the TwitterClient object from TwitterUserClient.
        twitter:TwitterClient? twitterClient = twitterUserClient.getTwitterClient();
        if (twitterClient is twitter:TwitterClient) {
            twitter:TwitterTrendsClient|error twitterTrendsClient = new(twitterClient);

            if (twitterTrendsClient is twitter:TwitterTrendsClient) {
                int locationId = 23424922;
                var trendsResponse = twitterTrendsClient->getTrendsByPlace(locationId);
                if (trendsResponse is twitter:TrendsList[]) {
                   io:println("Trends: ", trendsResponse);
                } else {
                   io:println("Error: ", trendsResponse);
                }
            } else {
                io:println("Error: ", twitterTrendsClient);
            }
        }
    } else {
        io:println("Error: ", twitterUserClient);
    }
    ```

### Sample

```ballerina
import wso2/twitter;
import ballerina/config;
import ballerina/io;
import ballerina/time;

string testClientId = config:getAsString("CLIENT_ID");
string testClientSecret = config:getAsString("CLIENT_SECRET");
string testAccessToken = config:getAsString("ACCESS_TOKEN");
string testAccessTokenSecret = config:getAsString("ACCESS_TOKEN_SECRET");

twitter:TwitterConfiguration twitterConfig = {
    clientId: testClientId,
    clientSecret: testClientSecret,
    accessToken: testAccessToken,
    accessTokenSecret: testAccessTokenSecret
};

int tweetId = 0;
string currentTimeStamp = "";
string userId = "4269258922";
int sinceId = 1108616819688927232;
int maxId = 1110365503862833154;

twitter:MediaParams mediaParams = {
    media: "https://twitter.com/andypiper/status/903615884664725505",
    //media:mediaIds,
    possiblySensitive: false
};

twitter:LocationParams locationParams = {
    placeInfo: (37.7821120598956, 122.400612831116),
    //placeInfo:"df51dec6f4ee2b2c",
    displayCoordinates: true
};

public function main(string... args) {

    io:println("--------------Calling tweet----------------");

    // Create Twitter client to invoke Tweet related functions.
    twitter:TwitterClient|error twitterClient = new(twitterConfig);

    if (twitterClient is twitter:TwitterClient) {
        time:Time time = time:currentTime();
        int currentTimeMills = time.time;
        currentTimeStamp = string.convert(currentTimeMills / 1000);
        string status = "Sample Tweet " + currentTimeStamp;

        var tweetResponse = twitterClient->tweet(status, trimUser = false, enableDmcommands = false,
            failDmcommands = true, mediaParams = mediaParams, locationParams = locationParams);

        if (tweetResponse is twitter:Tweet) {
            tweetId = untaint tweetResponse.id;
            io:println("Tweet Text: ", tweetResponse.text);
        } else {
            io:println("Error: ", tweetResponse);
        }

        io:println("--------------Calling replyToTweet----------------");
        twitter:StatusReplyParams replyParams = {
            inReplyToStatusId: tweetId,
            autoPopulateReplyMetadata: true,
            excludeReplyUserIds: userId
        };
        string reply = "Sample Tweet Reply " + currentTimeStamp;

        var replyToTweetResponse = twitterClient->replyToTweet(reply, replyParams, trimUser = false,
            enableDmcommands = false, failDmcommands = true, mediaParams = mediaParams,
            locationParams = locationParams);

        if (replyToTweetResponse is twitter:Tweet) {
            io:println("Tweet Reply Text: ", replyToTweetResponse.text);
        } else {
            io:println("Error: ", replyToTweetResponse);
        }

        io:println("--------------Calling retweet----------------");
        var retweetResponse = twitterClient->retweet(tweetId, trimUser = false);
        if (retweetResponse is twitter:Tweet) {
            io:println("Retweeted: ", retweetResponse.retweeted);
        } else {
            io:println("Error: ", retweetResponse);
        }

        io:println("--------------Calling createFavoriteTweet----------------");
        var favoriteTweetResponse = twitterClient->createFavoriteTweet(tweetId, includeEntities = false);

        if (favoriteTweetResponse is twitter:Tweet) {
            io:println("FavoritedTweet: ", favoriteTweetResponse.favorited);
        } else {
            io:println("Error: ", favoriteTweetResponse);
        }

        io:println("--------------Calling search----------------");
        string queryStr = "twitter";
        var searchResponse = twitterClient->search(queryStr, count = 20, lang = "eu", includeEntities = false,
            sinceId = sinceId);

        if (searchResponse is twitter:Search) {
            io:println("Search Result: ", searchResponse);
        } else {
            io:println("Error: ", searchResponse);
        }

        io:println("--------------Calling getHomeTimelineTweets----------------");

        var homeTimelineResponse = twitterClient->getHomeTimelineTweets(count = 20, sinceId = sinceId,
            maxId = maxId, trimUser = false, excludeReplies = false, includeEntities = false);

        if (homeTimelineResponse is twitter:Tweet[]) {
            io:println("HomeTimelineTweets: ", homeTimelineResponse);
        } else {
            io:println("Error: ", homeTimelineResponse);
        }

        io:println("--------------Calling getTweetMentions----------------");
        var tweetMentionsResponse = twitterClient->getTweetMentions(count = 5, sinceId = sinceId,
            maxId = maxId, trimUser = false, includeEntities = false);

        if (tweetMentionsResponse is twitter:Tweet[]) {
            io:println("Tweet Mentions: ", tweetMentionsResponse);
        } else {
            io:println("Error: ", tweetMentionsResponse);
        }

        io:println("--------------Calling getFollowers----------------");
        // Create a new User client using `twitterConfig`.
        twitter:TwitterUserClient|error twitterUserClientWithConfig = new(twitterConfig);
        if (twitterUserClientWithConfig is twitter:TwitterUserClient) {
            var followersResponseWithConfig = twitterUserClientWithConfig->getFollowers(screenName = "WSO2",
                cursor = -1, count = 10, skipStatus = true, includeUserEntities = false);

            if (followersResponseWithConfig is twitter:Followers) {
                io:println("Followers: ", followersResponseWithConfig.users);
            } else {
                io:println("Error: ", followersResponseWithConfig);
            }
        } else {
            io:println("Error: ", twitterUserClientWithConfig);
        }

        // Or Get the User client from the base/parent Twitter client.
        twitter:TwitterUserClient? twitterUserClient = twitterClient.getUserClient();
        if (twitterUserClient is twitter:TwitterUserClient) {
            var followersResponse = twitterUserClient->getFollowers(screenName = "WSO2", cursor = -1, count = 10,
                skipStatus = true, includeUserEntities = false);

            if (followersResponse is twitter:Followers) {
                io:println("Followers: ", followersResponse.users);
            } else {
                io:println("Error: ", followersResponse);
            }
        }

        io:println("--------------Calling getClosestTrendLocations----------------");
        float latitude = 34.0;
        float longitude = 67.0;
        // Create new Trends client using `twitterConfig`.
        twitter:TwitterTrendsClient|error twitterTrendsClientWithConfig = new(twitterConfig);
        if (twitterTrendsClientWithConfig is twitter:TwitterTrendsClient) {
            var locationResponseWithConfig = twitterTrendsClientWithConfig->getClosestTrendLocations(latitude,
                longitude);
            if (locationResponseWithConfig is twitter:Location[]) {
                io:println("Locations: ", locationResponseWithConfig);
            } else {
                io:println("Error: ", locationResponseWithConfig);
            }
        } else {
            io:println("Error: ", twitterTrendsClientWithConfig);
        }

        // Or Get the Trends client from the base/parent Twitter client.
        twitter:TwitterTrendsClient? twitterTrendsClient = twitterClient.getTrendsClient();
        if (twitterTrendsClient is twitter:TwitterTrendsClient) {
            var locationResponse = twitterTrendsClient->getClosestTrendLocations(latitude, longitude);
            if (locationResponse is twitter:Location[]) {
                io:println("Locations: ", locationResponse);
            } else {
                io:println("Error: ", locationResponse);
            }
        }

        // Get the `TwitterClient` object from twitterUserClient and then invoke Trends related functions.
        if (twitterUserClient is twitter:TwitterUserClient) {
            twitter:TwitterClient? twitterClient2 = twitterUserClient.getTwitterClient();
            if (twitterClient2 is twitter:TwitterClient) {
                twitter:TwitterTrendsClient|error twitterTrendsClient2 = new(twitterClient2);
                if (twitterTrendsClient2 is twitter:TwitterTrendsClient) {
                    var locationResponse2 = twitterTrendsClient2->getClosestTrendLocations(latitude, longitude);
                    if (locationResponse2 is twitter:Location[]) {
                        io:println("Locations: ", locationResponse2);
                    } else {
                        io:println("Error: ", locationResponse2);
                    }
                }
            }
        }

        io:println("--------------Calling getTopTrendsByPlace----------------");
        int locationId = 23424922;
        if (twitterTrendsClientWithConfig is twitter:TwitterTrendsClient) {
            var trendsResponseWithConfig = twitterTrendsClientWithConfig->getTrendsByPlace(locationId);
            if (trendsResponseWithConfig is twitter:TrendsList[]) {
                io:println("Trends: ", trendsResponseWithConfig);
            } else {
                io:println("Error: ", trendsResponseWithConfig);
            }
        } else {
            io:println("Error: ", twitterTrendsClientWithConfig);
        }

        if (twitterTrendsClient is twitter:TwitterTrendsClient) {
            var trendsResponse = twitterTrendsClient->getTrendsByPlace(locationId);
            if (trendsResponse is twitter:TrendsList[]) {
                io:println("Trends: ", trendsResponse);
            } else {
                io:println("Error: ", trendsResponse);
            }
        }
    } else {
        io:println("Error: ", twitterClient);
    }
}
```
