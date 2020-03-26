import ballerina/config;
import ballerina/test;
import ballerina/time;
import ballerina/stringutils;

int tweetId = 0;

TwitterConfiguration twitterConfig = {
    consumerKey: config:getAsString("CONSUMER_KEY"),
    consumerSecret: config:getAsString("CONSUMER_SECRET"),
    accessToken: config:getAsString("ACCESS_TOKEN"),
    accessTokenSecret: config:getAsString("ACCESS_TOKEN_SECRET")
};
Client twitterClient = new(twitterConfig);

@test:Config {}
function testTweet() {
    time:Time time = time:currentTime();
    string status = "Ballerina Twitter Connector: " + time:toString(time);
    var tweetResponse = twitterClient->tweet(status);

    if (tweetResponse is Status) {
        tweetId = <@untainted> tweetResponse.id;
        test:assertTrue(stringutils:contains(tweetResponse.text, status), "Failed to call tweet()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {
    dependsOn: ["testTweet"]
}
function testRetweet() {
    var tweetResponse = twitterClient->retweet(tweetId);
    if (tweetResponse is Status) {
        test:assertTrue(tweetResponse.retweeted, "Failed to call retweet()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {
    dependsOn: ["testRetweet"]
}
function testUnretweet() {
    var tweetResponse = twitterClient->unretweet(tweetId);
    if (tweetResponse is Status) {
        test:assertEquals(tweetResponse.id, tweetId, "Failed to call unretweet()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {
    dependsOn: ["testUnretweet"]
}
function testGetTweet() {
    var tweetResponse = twitterClient->getTweet(tweetId);
    if (tweetResponse is Status) {
        test:assertEquals(tweetResponse.id, tweetId, "Failed to call getTweet()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {
    dependsOn: ["testGetTweet"]
}
function testDeleteTweet() {
    var tweetResponse = twitterClient->deleteTweet(tweetId);
    if (tweetResponse is Status) {
        test:assertEquals(tweetResponse.id, tweetId, "Failed to call deleteTweet()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}

@test:Config {}
function testSearch() {
    string query = "#ballerina";
    var tweetResponse = twitterClient->search(query);
    if (tweetResponse is Status[]) {
        test:assertTrue(tweetResponse.length() > 0, "Failed to call search()");
    } else {
        test:assertFail(<string>tweetResponse.detail()["message"]);
    }
}
