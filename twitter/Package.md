Connects to Twitter from Ballerina. 

# Package Overview

This package provides a Ballerina API for the Twitter REST API. It contains operations that update the current status, retweet a tweet, 
untweet a retweeted status, search for tweets, retrieve a status, destroy a status, retrieve closest trend locations, and retrieve top trends by place.

**Status Operations**

The `wso2/twitter` package contains operations that work with statuses. You can update the current status, retweet a tweet, 
untweet a retweeted status, retrieve a status, and destroy a status.

**Search Operations**

The `wso2/twitter` package contains operations that search for tweets. 

**Trends Operations**

The `wso2/twitter` package contains operations that retrieve closest trend locations and retrieve top trends by place.



## Compatibility
|                    |    Version     |  
| -----------------  | -------------- | 
| Ballerina Language | 0.970.0-beta19 |
|  Twitter API       |   1.1          |


## Sample

First, import the `wso2/twitter` package into the Ballerina project.

```ballerina
import wso2/twitter;
```
    
The Twitter connector can be instantiated using the Consumer Key (API Key), Consumer Secret (API Secret), Access Token, 
and Access Token Secret in the Twitter client config.

**Obtaining API Keys and Tokens to Run the Sample**

1. Visit https://apps.twitter.com/app/new and log in.
2. Provide the required information about the application.
3. Agree to the Developer Agreement and click **Create your Twitter application**.
4. After creating your Twitter application, your Consumer Key and Consumer Secret will be displayed in the Keys and Access Tokens tab of your app on Twitter.
5. Click the **Keys and Access Tokens** tab, and then enable your Twitter account to use this application by clicking the **Create my access token** button.
6. Copy the Consumer key (API key), Consumer Secret, Access Token, and Access Token Secret from the screen.


You can now enter the credentials in the Twitter client config:
```ballerina
 endpoint twitter:Client twitterClient {
       clientId:"<your_consumer_key>",
       clientSecret:"<your_consumer_secret>",
       accessToken:"<your_access_token>",
       accessTokenSecret:"<your_access_token_secret>"
 };
```

The `tweet` function updates the current status. `status` is the text message of the status update.

   `var tweetResponse = twitterClient->tweet(status);`
   
If the status was updated successfully, the response from the `tweet` function is a `Status` object with the ID of the status, created time of status, etc. If the status update was unsuccessful, the response is a `TwitterError`. The `match` operation can be used to handle the response if an error occurs.

```ballerina
match tweetResponse {
   Status twitterStatus => {
       //If successful, returns the tweet message or ID of the status.
       string tweetId = <string> twitterStatus.id;
       string text = twitterStatus.text;
       io:println("Tweet ID: " + tweetId);
       io:println("Tweet: " + text);
   }
   //Unsuccessful attempts return a Twitter error.
   twitter:TwitterError e => io:println(e); 
}
```

The `retweet` function retweets a tweet message. It returns a `Status` object if successful or `TwitterError` if unsuccessful.

```ballerina
var tweetResponse = twitterClient->retweet (tweetId);
match tweetResponse {
    Status twitterStatus => io:println("Retweeted: " +    twitterStatus.retweeted);
    twitter:TwitterError e => io:println(e);
}
```

The `search` function searches for tweets using a query string. It returns a `TwitterError` when unsuccessful.
```ballerina
var tweetResponse = twitterClient->search (queryStr);
match tweetResponse {
    Status[] twitterStatus => io:println(twitterStatus);
    twitter:TwitterError e => io:println(e);
}
```

