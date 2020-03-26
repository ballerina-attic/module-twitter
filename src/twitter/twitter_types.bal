# Define the status, AKA Tweet.
#
# + createdAt - Created time of the status
# + id - Id of the status
# + text - Text message of the status
# + source - Source app of the status
# + truncated - Whether the status is truncated or not
# + favorited - Whether the status is favorited or not
# + retweeted - Whether the status is retweeted or not
# + favoriteCount - Favourite count of the status
# + retweetCount - Retweet count of the status
# + lang - Language of the status
public type Status record {
    string createdAt = "";
    int id = 0;
    string text = "";
    string 'source = "";
    boolean truncated = false;
    boolean favorited = false;
    boolean retweeted = false;
    int favoriteCount = 0;
    int retweetCount = 0;
    string lang = "";
};

# Define the advanced search parameters.
#
# + geocode - The parameter value is specified by "latitude,longitude,radius", where radius units must be specified as
#             either "mi" (miles) or "km" (kilometers)
# + lang - The language, given by an ISO 639-1 code
# + locale - The language of the query
# + resultType - Specifies what type of search results prefer to receive. The current default is "mixed"
#                Valid values include:
#                "mixed" : Include both popular and real time results in the response
#                "recent" : return only the most recent results in the response
#                "popular" : return only the most popular results in the response
# + count - The number of tweets to return per page, up to a maximum of 100. Defaults to 15
# + until - Returns tweets created before the given date. Date should be formatted as YYYY-MM-DD.
#           The search index has a 7-day limit. In other words, no tweets will be found for a date older than one week
# + sinceId - Returns results with an ID greater than (that is, more recent than) the specified ID
# + maxId - Returns results with an ID less than (that is, older than) or equal to the specified ID
# + includeEntities - The entities node will not be included when set to false
public type AdvancedSearch record {|
    string geocode?;
    string lang?;
    string locale?;
    string resultType?;
    string count?;
    string until?;
    int sinceId?;
    int maxId?;
    boolean includeEntities?;
|};
