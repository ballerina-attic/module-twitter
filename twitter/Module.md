Connects to Twitter from Ballerina. 

# Module Overview

The Twitter connector allows you to tweet, retweet, untweet, and search for tweets through the Twitter REST API.
You can also retrieve and destroy a status, and retrieve closest trend locations and top trends.

**Status Operations**

The `wso2/twitter` module contains operations that work with statuses. You can update the current status, retweet a tweet, 
untweet a retweeted status, retrieve a status, and destroy a status.

**Search Operations**

The `wso2/twitter` module contains operations that search for tweets. 

**Trends Operations**

The `wso2/twitter` module contains operations that retrieve closest trend locations and retrieve top trends by place.


## Compatibility
|                    |    Version     |  
|:------------------:|:--------------:|
| Ballerina Language |   0.990.3      |
| Twitter API        |   1.1          |


## Sample

First, import the `wso2/twitter` module into the Ballerina project.

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


You can now enter the credentials in the Twitter client config and create Twitter client by passing the config:
```ballerina
twitter:TwitterConfiguration twitterConfig = {
    clientId: testClientId,
    clientSecret: testClientSecret,
    accessToken: testAccessToken,
    accessTokenSecret: testAccessTokenSecret
};

twitter:Client twitterClient = new(twitterConfig);
```

The `tweet` function updates the current status. `status` is the text message of the status update.

   `var tweetResponse = twitterClient->tweet("This is a sample tweet");`
   
If the status was updated successfully, the response from the `tweet` function is a `Status` object with the ID of the status, created time of status, etc. If the status update was unsuccessful, the response is a `error`.

```ballerina
    string status = "Twitter endpoint test";
    var result = twitterClient->tweet(status);
    if (result is twitter:Status) {
        // If successful, print the tweet ID and text.
        io:println("Tweet ID: ", result.id);
        io:println("Tweet: ", result.text);
    } else {
        // If unsuccessful, print the error returned.
        io:println("Error: ", result);
    }
```

The `retweet` function retweets a tweet message. It returns a `Status` object if successful or an `error` if unsuccessful.

```ballerina
    int tweetId = 1093833789346861057;
    var tweetResponse = twitterClient->retweet(tweetId);
    if (tweetResponse is twitter:Status) {
        io:println("Retweeted: " + tweetResponse.retweeted);
    } else {
        io:println("Error: ", tweetResponse);
    }
```

The `search` function searches for tweets using a query string. It returns a `Status[]` object if successful or an `error` if unsuccessful.

```ballerina
    string queryStr = "twitter";
    twitter:SearchRequest request = {
        tweetsCount:"100"
    };
    var tweetResponse = twitterClient->search(queryStr, request);
    if (tweetResponse is twitter:Status[]) {
        io:println("Search Result :");
        io:println(tweetResponse);
    } else {
        io:println("Error: ", tweetResponse);
    }
```
