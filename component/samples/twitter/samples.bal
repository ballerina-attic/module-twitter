import org.wso2.ballerina.connectors.twitter;
import ballerina.net.http;

function main (string[] args) {

    endpoint<twitter:ClientConnector> twitterConnector {
        create twitter:ClientConnector(args[1], args[2], args[3], args[4]);
    }

    http:Response tweetResponse;
    json tweetJSONResponse;
    if (args[0] == "tweet") {
        tweetResponse = twitterConnector.tweet (args[5]);

        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());
    } else if (args[0] == "search") {
        tweetResponse = twitterConnector.search (args[5]);

        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());
    } else if (args[0] == "retweet") {
        tweetResponse = twitterConnector.retweet (args[5]);

        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());
    } else if (args[0] == "unretweet") {
        tweetResponse = twitterConnector.unretweet (args[5]);

        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());
    } else if (args[0] == "showStatus") {
        tweetResponse = twitterConnector.showStatus (args[5]);

        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());
    } else if (args[0] == "destroyStatus") {
        tweetResponse = twitterConnector.destroyStatus (args[5]);

        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());
    } else if (args[0] == "getClosestTrendLocations") {
        tweetResponse = twitterConnector.getClosestTrendLocations (args[5], args[6]);

        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());
    } else if (args[0] == "getTopTrendsByPlace") {
        tweetResponse = twitterConnector.getTopTrendsByPlace (args[5]);

        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());
    } else {
        println("====== Update Status =====");
        tweetResponse = twitterConnector.tweet ("Tweet messages");
        tweetJSONResponse = tweetResponse.getJsonPayload();
        string tweetId;
        tweetId, _ = (string)tweetJSONResponse["$.id_str"];
        println(tweetJSONResponse.toString());

        println("====== search =====");
        tweetResponse = twitterConnector.search ("Tweet messages");
        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());

        println("====== Retweet a tweet =====");
        tweetResponse = twitterConnector.retweet (tweetId);
        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());

        println("====== Untweet a retweeted status =====");
        tweetResponse = twitterConnector.unretweet (tweetId);
        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());

        println("====== Retrive a single status =====");
        tweetResponse = twitterConnector.showStatus (tweetId);
        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());

        println("====== Distroy a status =====");
        tweetResponse = twitterConnector.destroyStatus (tweetId);
        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());

        println("====== Retrive closest trend locations =====");
        tweetResponse = twitterConnector.getClosestTrendLocations ("37.781157", "-122.400612831116");
        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());

        println("====== Retrieve top trends by place =====");
        tweetResponse = twitterConnector.getTopTrendsByPlace ("1");
        tweetJSONResponse = tweetResponse.getJsonPayload();
        println(tweetJSONResponse.toString());
    }
}