function convertToStatus(json response) returns Status {
    Status status = {
        createdAt: <string>response.created_at,
        id: <int>response.id,
        text: <string>response.text,
        'source: <string>response.'source,
        truncated: <boolean>response.truncated,
        favorited: <boolean>response.favorited,
        retweeted: <boolean>response.retweeted,
        favoriteCount: <int>response.favorite_count,
        retweetCount: <int>response.retweet_count,
        lang: <string>response.lang
    };
    return status;
}

function convertToStatuses(json[] response) returns Status[] {
    Status[] statuses = [];
    int i = 0;
    foreach json status in response {
        statuses[i] = convertToStatus(status);
        i = i + 1;
    }
    return statuses;
}
