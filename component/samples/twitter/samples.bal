import org.wso2.ballerina.connectors.twitter;
import ballerina.net.http;

function main (string[] args) {

    endpoint<twitter:ClientConnector> twitterConnector {
        create twitter:ClientConnector(args[1], args[2], args[3], args[4]);
    }

    http:Response tweetResponse = {};
    http:HttpConnectorError e;
    json tweetJSONResponse;

    if (args[0] == "tweet") {
        string status = args[5];
        tweetResponse, e = twitterConnector.tweet (status);
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }
    } else if (args[0] == "search") {
        string query = args[5];
        tweetResponse, e = twitterConnector.search (query);
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }
    } else if (args[0] == "retweet") {
        string id = args[5];
        tweetResponse, e = twitterConnector.retweet (id);
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }
    } else if (args[0] == "unretweet") {
        string id = args[5];
        tweetResponse, e = twitterConnector.unretweet (id);
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }
    } else if (args[0] == "showStatus") {
        string id = args[5];
        tweetResponse, e = twitterConnector.showStatus (id);
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }
    } else if (args[0] == "destroyStatus") {
        string id = args[5];
        tweetResponse, e = twitterConnector.destroyStatus (id);
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }
    } else if (args[0] == "getClosestTrendLocations") {
        string latitude = args[5];
        string longitude = args[6];
        tweetResponse, e = twitterConnector.getClosestTrendLocations (latitude, longitude);
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }
    } else if (args[0] == "getTopTrendsByPlace") {
        string locationId = args[5];
        tweetResponse, e = twitterConnector.getTopTrendsByPlace (locationId);
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }
    } else {
        println("====== Update Status =====");
        tweetResponse, e = twitterConnector.tweet ("Tweet messages");
        string tweetId;
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
            tweetId, _ = (string)tweetJSONResponse["$.id_str"];
        } else {
            println(e);
        }

        println("====== search =====");
        tweetResponse, e = twitterConnector.search ("Tweet messages");
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }

        if(tweetId != null) {
            println("====== Retweet a tweet =====");
            tweetResponse, e = twitterConnector.retweet (tweetId);
            if(e == null) {
                tweetJSONResponse = tweetResponse.getJsonPayload();
                println(tweetJSONResponse.toString());
            } else {
                println(e);
            }

            println("====== Untweet a retweeted status =====");
            tweetResponse, e = twitterConnector.unretweet (tweetId);
            if(e == null) {
                tweetJSONResponse = tweetResponse.getJsonPayload();
                println(tweetJSONResponse.toString());
            } else {
                println(e);
            }

            println("====== Retrive a single status =====");
            tweetResponse, e = twitterConnector.showStatus (tweetId);
            if(e == null) {
                tweetJSONResponse = tweetResponse.getJsonPayload();
                println(tweetJSONResponse.toString());
            } else {
                println(e);
            }

            println("====== Distroy a status =====");
            tweetResponse, e = twitterConnector.destroyStatus (tweetId);
            if(e == null) {
                tweetJSONResponse = tweetResponse.getJsonPayload();
                println(tweetJSONResponse.toString());
            } else {
                println(e);
            }
        }

        println("====== Retrive closest trend locations =====");
        tweetResponse, e = twitterConnector.getClosestTrendLocations ("37.781157", "-122.400612831116");
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }

        println("====== Retrieve top trends by place =====");
        tweetResponse, e = twitterConnector.getTopTrendsByPlace ("1");
        if(e == null) {
            tweetJSONResponse = tweetResponse.getJsonPayload();
            println(tweetJSONResponse.toString());
        } else {
            println(e);
        }
    }
}