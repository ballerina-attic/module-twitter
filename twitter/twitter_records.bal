// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

public type SearchResultType RESULT_TYPE_MIXED|RESULT_TYPE_RECENT|RESULT_TYPE_POPULAR;

public const RESULT_TYPE_MIXED = "mixed";
public const RESULT_TYPE_RECENT = "recent";
public const RESULT_TYPE_POPULAR = "popular";

# Twitter Connector configurations can be setup here.
#
# + accessToken - The access token of the Twitter account.
# + accessTokenSecret - The access token secret of the Twitter account.
# + clientId - The consumer key of the Twitter account.
# + clientSecret - The consumer secret of the Twitter account.
# + clientConfig - Client endpoint configurations provided by the user.
public type TwitterConfiguration record {
    string accessToken;
    string accessTokenSecret;
    string clientId;
    string clientSecret;
    http:ClientEndpointConfig clientConfig = {};
};

# Input parameters to add the reply to authenticating user's current status.
#
# + inReplyToStatusId - The ID of an existing status that the update is in reply to.
# + autoPopulateReplyMetadata - If set to true and used with inReplyToStatusId, leading @mentions will be looked up
#                               from the original Tweet, and added to the new Tweet from there. This wil append
#                               @mentions into the metadata of an extended Tweet as a reply chain grows, until the
#                               limit on @mentions is reached.
# + excludeReplyUserIds - When used with autoPopulateReplyMetadata, a comma-separated list of user ids which will be
#                         removed from the server-generated @mentions prefix on an extended Tweet.
public type StatusReplyParams record {|
    int inReplyToStatusId;
    boolean autoPopulateReplyMetadata?;
    string excludeReplyUserIds?;
|};

# Input parameters to add media such as attachment url or mediaIds to authenticating user's current status.
#
# + media - (attachment_url as string or media_ids as int[])
#           attachment_url: In order for a URL to not be counted in the status body of an extended Tweet, provide a
#           URL as a Tweet attachment. This URL must be a Tweet permalink, or Direct Message deep link.
#           media_ids: A list of media_ids as an array to associate with the Tweet.
# + possiblySensitive - If you upload Tweet media that might be considered sensitive content such as nudity,
#                       or medical procedures, you must set this value to true.
public type MediaParams record {|
    string|int[] media;
    boolean possiblySensitive?;
|};

# Input parameters to add location details to authenticating user's current status.
#
# + placeInfo - (latitude, longitude as (float, float) or place_id as string)
#               latitude, longitude: The latitude, longitude of the location.
#               place_id: Id of the place in the world.
# + displayCoordinates - Whether or not to put a pin on the exact coordinates a Tweet has been sent from.
public type LocationParams record {|
    (float, float)|string placeInfo;
    boolean displayCoordinates?;
|};

# Followers is a cursored collection of followers.
#
# + users - Collection of User object.
# + next_cursor - Since the Followers list breaks into pages, next_cursor will allow to navigate forth in the list.
# + next_cursor_str - String representation of next_cursor.
# + previous_cursor - Since the Followers list breaks into pages, previous_cursor will allow to navigate back in the list.
# + previous_cursor_str - String representation of previous_cursor.
# + total_count - Total no of Followers count.
public type Followers record {
    TruncatedUser[]|User[] users;
    int next_cursor;
    string next_cursor_str;
    int previous_cursor;
    string previous_cursor_str;
    int? total_count;
};

# The User object contains public Twitter account metadata and describes the of the Tweet. Users can be anyone
# or anything. They Tweet, Retweet, add Quotes to Tweets, follow others, create lists, have a home timeline,
# can be mentioned, and can be looked up in bulk.
#
# + id - The integer representation of the unique identifier for the User.
# + id_str - The string representation of the unique identifier for the User.
# + name - The name of the user, as they’ve defined it.
# + screen_name - The screen name, handle, or alias that this user identifies themselves with.
# + location - The user-defined location for this account’s profile.
# + url - A URL provided by the user in association with their profile.
# + description - The user-defined UTF-8 string describing their account.
# + entities - It describe URLs that appear in the user defined profile URL and description fields..
# + protected - When true, indicates that this user has chosen to protect their Tweets.
# + followers_count - The number of followers this account currently has.
# + friends_count - The number of users this account is following (AKA their "followings").
# + listed_count - The number of public lists that this user is a member of.
# + created_at - The UTC datetime that the user account was created on Twitter.
# + favourites_count - The number of Tweets this user has liked in the account’s lifetime.
# + utc_offset - UTC offset.
# + time_zone - Time zone.
# + geo_enabled - When true, indicates that the user has enabled the possibility of geotagging their Tweets.
# + verified - When true, indicates that the user has a verified account.
# + statuses_count - The number of Tweets (including retweets) issued by the user.
# + lang - The BCP 47 code for the user’s self-declared user interface language.
# + contributors_enabled - Indicates that the user has an account with "contributor mode" enabled, allowing for Tweets
#                          issued by the user to be co-authored by another account.
# + is_translator - When true, indicates that the user is a participant in Twitter’s translator community.
# + is_translation_enabled - Whether translation is enabled or not.
# + profile_background_color - The hexadecimal color chosen by the user for their background.
# + profile_background_image_url - A HTTP-based URL pointing to the background image the user has uploaded for
#                                  their profile.
# + profile_background_image_url_https - A HTTPS-based URL pointing to the background image the user has uploaded
#                                        for their profile.
# + profile_background_tile - When true, indicates that the user’s profile_background_image_url should be
#                             tiled when displayed.
# + profile_banner_url - The HTTPS-based URL pointing to the standard web representation of the user’s uploaded
#                        profile banner.
# + profile_image_url - A HTTP-based URL pointing to the user’s profile image.
# + profile_image_url_https - A HTTPS-based URL pointing to the user’s profile image.
# + profile_link_color - The hexadecimal color the user has chosen to display links with in their Twitter UI.
# + profile_sidebar_border_color - The hexadecimal color the user has chosen to display sidebar borders with in
#                                  their Twitter UI.
# + profile_sidebar_fill_color - The hexadecimal color the user has chosen to display sidebar backgrounds with
#                                in their Twitter UI.
# + profile_text_color - The hexadecimal color the user has chosen to display text with in their Twitter UI.
# + profile_use_background_image - When true, indicates the user wants their uploaded background image to be used.
# + has_extended_profile - When true, indicates that the user has extended their user profile.
# + default_profile - When true, indicates that the user has not altered the theme or background of their user profile.
# + default_profile_image - When true, indicates that the user has not uploaded their own profile image and a
#                           default image is used instead.
# + follow_request_sent - Whether the authenticating user has requested to follow this user or not.
# + following - When true, indicates that the authenticating user is following this user.
# + live_following -
# + notifications - Indicates whether the authenticated user has chosen to receive this user’s Tweets by SMS.
# + muting - When true, indicates that the authenticating user has been muted.
# + blocking - When true, indicates that the authenticating user has been blocked.
# + blocked_by - When true, indicates that the authenticating user has blocked you.
# + status - Returns the current status of the user.
# + translator_type - Type of the translator.
# + derived - Collection of Enrichment metadata derived for user.
# + withheld_in_countries - When present, indicates a list of uppercase two-letter country codes
#                           the content is withheld from.
# + withheld_scope - When present, indicates that the content being withheld is a "user".
public type User record {
    int id;
    string id_str;
    string name;
    string screen_name;
    string? location;
    string? url;
    string? description?;
    UserEntities entities?;
    boolean protected;
    int followers_count;
    int friends_count;
    int listed_count;
    string created_at;
    int favourites_count;
    json utc_offset;
    json time_zone;
    boolean geo_enabled;
    boolean verified;
    int statuses_count;
    string lang;
    boolean contributors_enabled;
    boolean is_translator;
    boolean is_translation_enabled?;
    string profile_background_color;
    string? profile_background_image_url;
    string? profile_background_image_url_https;
    boolean profile_background_tile?;
    string profile_banner_url?;
    string profile_image_url;
    string profile_image_url_https;
    string profile_link_color;
    string profile_sidebar_border_color;
    string profile_sidebar_fill_color?;
    string profile_text_color;
    boolean profile_use_background_image;
    boolean has_extended_profile;
    boolean default_profile;
    boolean default_profile_image;
    boolean follow_request_sent?;
    boolean? following;
    boolean live_following;
    boolean? notifications;
    boolean muting;
    boolean blocking;
    boolean blocked_by;
    Tweet status?;
    string translator_type?;
    json derived?;
    string[] withheld_in_countries?;
    string withheld_scope?;
};

# The User object contains public Twitter account metadata and describes the of the Tweet. Users can be anyone
# or anything. They Tweet, Retweet, add Quotes to Tweets, follow others, create lists, have a home timeline,
# can be mentioned, and can be looked up in bulk.
# If trimUser = true, the response will include a user object including only the author's ID.
#
# + id - The integer representation of the unique identifier for the User.
# + id_str - The string representation of the unique identifier for the User.
public type TruncatedUser record {
    int id;
    string id_str;
};

# Represent Tweet object. Tweets are also known as "status updates".
#
# + created_at - UTC time when this Tweet was created.
# + id - The integer representation of the unique identifier for the Tweet.
# + id_str - The string representation of the unique identifier for the Tweet.
# + text - The actual UTF-8 text of the status update.
# + truncated - Indicates whether the value of the text parameter was truncated, for example, as a result of a retweet
#               exceeding the original Tweet text length limit of 140 characters. Truncated text will
#               end in ellipsis, like this ...
# + metadata - It describes a Tweet result.
# + source - Utility used to post the Tweet, as an HTML-formatted string.
# + in_reply_to_status_id - If the represented Tweet is a reply, this field will contain the integer representation
#                           of the original Tweet’s ID.
# + in_reply_to_status_id_str - If the represented Tweet is a reply, this field will contain the string representation
#                               of the original Tweet’s ID.
# + in_reply_to_user_id - If the represented Tweet is a reply, this field will contain the integer representation
#                         of the original Tweet’s author ID.
# + in_reply_to_user_id_str - If the represented Tweet is a reply, this field will contain the string representation
#                             of the original Tweet’s author ID.
# + in_reply_to_screen_name - If the represented Tweet is a reply, this field will contain the screen name of the
#                             original Tweet’s author.
# + user - The user object who posted this Tweet.
# + geo - Represents the geographic location of the Tweet.
# + place - A Place object. When present, indicates that the tweet is associated a Place .
# + coordinates - Represents the geographic location of the Tweet as reported by the user or client application.
# + contributors - It describes contributors details.
# + is_quote_status - Indicates whether this is a Quoted Tweet.
# + retweet_count - Number of times this Tweet has been retweeted.
# + favorite_count - Indicates approximately how many times this Tweet has been liked by Twitter users.
# + favorited - Indicates whether this Tweet has been liked by the authenticating user.
# + retweeted - Indicates whether this Tweet has been Retweeted by the authenticating user.
# + possibly_sensitive - This field only surfaces when a Tweet contains a link. The meaning of the field doesn’t
#                        pertain to the Tweet content itself, but instead it is an indicator that the URL contained in
#                        the Tweet may contain content or media identified as sensitive content.
# + possibly_sensitive_appealable - It’s a legacy value that can be ignored.
# + lang - When present, indicates a BCP 47 language identifier corresponding to the machine-detected language of the
#          Tweet text, or und if no language could be detected.
# + retweeted_status - Users can amplify the broadcast of Tweets authored by other users by retweeting . Retweets
#                      can be distinguished from typical Tweets by the existence of a retweeted_status attribute.
#                      This attribute contains a representation of the original Tweet that was retweeted.
# + quoted_status_id - This field only surfaces when the Tweet is a quote Tweet. This field contains the integer value
#                      Tweet ID of the quoted Tweet.
# + quoted_status_id_str - This field only surfaces when the Tweet is a quote Tweet. This is the string representation
#                      Tweet ID of the quoted Tweet.
# + quoted_status - This field only surfaces when the Tweet is a quote Tweet. This attribute contains the Tweet object
#                   of the original Tweet that was quoted.
# + quote_count - Indicates approximately how many times this Tweet has been quoted by Twitter users.
# + reply_count - Number of times this Tweet has been replied to.
# + entities - Entities which have been parsed out of the text of the Tweet.
# + extended_entities - When between one and four native photos or one video or one animated GIF are in Tweet,
#                       contains an array 'media' metadata.
# + filter_level - Indicates the maximum value of the filter_level parameter which may be used and still stream this
#                  Tweet. So a value of medium will be streamed on none, low, and medium streams.
# + matching_rules - Present in filtered products such as Twitter Search and PowerTrack. Provides the id and tag
#                    associated with the rule that matched the Tweet.
# + current_user_retweet - Details the Tweet ID of the user’s own retweet (if existent) of a Tweet.
# + scopes - A set of key-value pairs indicating the intended contextual delivery of the containing Tweet.
# + withheld_copyright - When present and set to "true", it indicates that this piece of content has been withheld
#                        due to a DMCA complaint.
# + withheld_in_countries - When present, indicates a list of uppercase two-letter country codes this content
#                           is withheld from.
# + withheld_scope - When present, indicates whether the content being withheld is the "status" or a "user".
public type Tweet record {
    string created_at;
    int id;
    string id_str;
    string text;
    boolean truncated;
    TweetMetadata metadata?;
    string source;
    int? in_reply_to_status_id;
    string? in_reply_to_status_id_str;
    int? in_reply_to_user_id;
    string? in_reply_to_user_id_str;
    string? in_reply_to_screen_name;
    TruncatedUser|User user?;
    Geo? geo;
    Place? place;
    Geo? coordinates;
    json contributors?;
    boolean is_quote_status;
    int retweet_count;
    int? favorite_count;
    boolean? favorited;
    boolean retweeted;
    boolean? possibly_sensitive?;
    boolean possibly_sensitive_appealable?;
    string? lang;
    Tweet retweeted_status?;
    int quoted_status_id?;
    string quoted_status_id_str?;
    Tweet quoted_status?;
    int? quote_count?;
    int reply_count?;
    Entities entities?;
    ExtendedEntities extended_entities?;
    string filter_level?;
    Rule[] matching_rules?;
    TweetIdentifier current_user_retweet?;
    json scopes?;
    boolean withheld_copyright?;
    string[] withheld_in_countries?;
    string withheld_scope?;
};

# TweetIdentifier represents the id by which a Tweet can be identified.
#
# + id - The integer representation of the unique identifier for the Tweet.
# + id_str - The string representation of the unique identifier for the Tweet.
public type TweetIdentifier record {
	int id;
	string id_str;
};

# Reprecents Rule object.
#
# + tag - The tag associated with the rule that matched the Tweet.
# + id - The id associated with the rule that matched the Tweet.
# + id_str - The string representation of id associated with the rule that matched the Tweet.
public type Rule record {
    string tag;
    int id;
    string id_str;
};

# TweetMetadata describes a Tweet result.
#
# + result_type - Specifies what type of results you would prefer to receive.
# + iso_language_code - ISO language code.
public type TweetMetadata record {
    string result_type;
    string iso_language_code;
};

# Places are specific, named locations with corresponding geo coordinates.
#
# + attributes - List of place attributes.
# + contained_within - Represent a collection of Place object. Setting this value means only places
#                      within the given Place can be found.
# + bounding_box - A bounding box of coordinates which encloses a place.
# + country - Name of the country containing this place.
# + country_code - Shortened country code representing the country containing this place.
# + full_name - Full human-readable representation of the place’s name.
# + id - ID representing a place.
# + name - Short human-readable representation of the place’s name.
# + place_type - The type of location represented by a place.
# + url - URL representing the location of additional place metadata for a place.
public type Place record {
	json attributes;
    Place[] contained_within?;
	BoundingBox bounding_box;
	string country;
	string country_code;
	string full_name;
	string id;
	string name;
	string place_type;
	string url;
};

# A bounding box of coordinates which encloses a place.
#
# + coordinates - A series of longitude and latitude points, defining a box which will contain the
#                 Place entity this bounding box is related to.
# + ^"type" - The type of data encoded in the coordinates property.
public type BoundingBox record {
	json coordinates;
	string ^"type";
};

# Represents the geographic location of the Tweet.
#
# + coordinates - The longitude and latitude of the Tweet’s location, as a collection in the form [longitude, latitude].
# + ^"type" - The type of data encoded in the coordinates property.
public type Geo record {
    float[] coordinates;
    string ^"type";
};

# It describe URLs that appear in the user defined profile URL and description fields.
#
# + url - URLs that appear in the user defined profile URL.
# + description - Description fields.
public type UserEntities record {
	Entities url?;
	Entities description;
};

# Entities provide metadata and additional contextual information about content posted on Twitter.
#
# + hashtags - Represents hashtags which have been parsed out of the Tweet text.
# + urls - Represents URLs included in the text of a Tweet.
# + user_mentions - Represents other Twitter users mentioned in the text of the Tweet.
# + media - Represents media elements uploaded with the Tweet.
# + symbols - Represents symbols, i.e. $cashtags, included in the text of the Tweet.
# + polls - Represents Twitter Polls included in the Tweet.
public type Entities record {
    HashtagEntity[] hashtags?;
    URLEntity[] urls;
    MentionEntity[] user_mentions?;
    MediaEntity[] media?;
    SymbolEntity[] symbols?;
    PollEntity[] polls?;
};

# Represents hashtags properties which have been parsed out of the Tweet text.
#
# + indices - An array of integers indicating the offsets within the Tweet text where the hashtag begins and ends.
#             The first integer represents the location of the # character in the Tweet text string. The second integer
#             represents the location of the first character after the hashtag.
# + text - Name of the hashtag, minus the leading ‘#’ character.
public type HashtagEntity record {
    int[] indices;
    string text;
};

# Represents an object for every link included in the Tweet body, and include an empty array if no links are present.
#
# + url - Wrapped URL, corresponding to the value embedded directly into the raw Tweet text, and the
#         values for the indices parameter.
# + expanded_url - Expanded version of `display_url`.
# + display_url - URL pasted/typed into Tweet.
# + indices - An array of integers representing offsets within the Tweet text where the URL begins and ends. The first
#             integer represents the location of the first character of the URL in the Tweet text. The second integer
#             represents the location of the first non-URL character after the end of the URL.
public type URLEntity record {
    string url;
    string expanded_url;
    string display_url;
    int[] indices;
};

# The entities section will contain a user_mentions array containing an object for every user mention included in the
# Tweet body, and include an empty array if no user mention is present.
#
# + screen_name - Screen name of the referenced user.
# + name - Display name of the referenced user.
# + id - ID of the mentioned user, as an integer.
# + id_str - If of the mentioned user, as a string.
# + indices - An array of integers representing the offsets within the Tweet text where the user reference begins and
#             ends. The first integer represents the location of the ‘@’ character of the user mention. The second
#             integer represents the location of the first non-screenname character following the user mention.
public type MentionEntity record {
    string screen_name;
    string name;
    int id;
    string id_str;
    int[] indices;
};

# The entities section will contain a symbols array containing an object for every $cashtag included in the Tweet body,
# and include an empty array if no symbol is present.
#
# + indices - An array of integers indicating the offsets within the Tweet text where the symbol/cashtag begins and
#             ends. The first integer represents the location of the $ character in the Tweet text string. The second
#             integer represents the location of the first character after the cashtag.
# + text - Name of the cashhtag, minus the leading ‘$’ character.
public type SymbolEntity record {
    int[] indices;
    string text;
};

# The entities section will contain a polls array containing a single poll object if the Tweet contains a poll.
# If no poll is included, there will be no polls array in the entities section.
#
# + options - An array of options, each having a poll position, and the text for that position.
# + end_datetime - Time stamp (UTC) of when poll ends.
# + duration_minutes - Duration of poll in minutes.
public type PollEntity record {
    Option[] options;
    string end_datetime;
    string duration_minutes;
};

# Reprecent Option object.
#
# + position - Poll position.
# + text - The text for that position.
public type Option record {
    int position;
    string text;
};

# Represents media elements uploaded with the Tweet.
#
# + id - ID of the media expressed as a 64-bit integer.
# + id_str - ID of the media expressed as a string.
# + indices - An array of integers indicating the offsets within the Tweet text where the URL begins and ends.
#             The first integer represents the location of the first character of the URL in the Tweet text. The second
#             integer represents the location of the first non-URL character occurring after the URL (or the end of the
#             string if the URL is the last part of the Tweet text).
# + media_url - An http:// URL pointing directly to the uploaded media file.
# + media_url_https - An https:// URL pointing directly to the uploaded media file, for embedding on https pages.
# + url - Wrapped URL for the media link.
# + display_url - URL of the media to display to clients.
# + expanded_url - An expanded version of display_url. Links to the media display page.
# + ^"type" - Type of uploaded media. Possible types include photo, video, and animated_gif.
# + sizes - An object showing available sizes for the media file.
# + source_status_id - For Tweets containing media that was originally associated with a different tweet,
#                      this ID points to the original Tweet.
# + source_status_id_str - For Tweets containing media that was originally associated with a different tweet,
#                          this string-based ID points to the original Tweet.
# + source_user_id - Source user Id.
# + source_user_id_str - String representation of source user Id.
# + video_info - It contains video-related properties.
# + additional_media_info - It contains additional media properties.
# + features - It contains video related features.
public type MediaEntity record {
    int id;
    string id_str;
    int[] indices;
    string media_url;
    string media_url_https;
    string url;
    string display_url;
    string expanded_url;
    string ^"type";
    MediaSizes sizes;
    int? source_status_id?;
    string? source_status_id_str?;
    int source_user_id?;
    string source_user_id_str?;
    VideoInfo? video_info?;
    json additional_media_info?;
    json features?;
};

# It contains video-related properties
#
# + aspect_ratio - The aspect ratio of the video, as a simplified fraction of width and height in a 2-element array.
# + duration_millis - The length of the video, in milliseconds.
# + variants - Different encodings/streams of the video. At least one variant is returned for each video entry.
public type VideoInfo record {
    int[] aspect_ratio;
    int duration_millis?;
    VideoVariant[] variants;
};

# Represent Different encodings/streams of the video.
#
# + content_type - The simplified type of the video format, such as video/mp4 or video/webm.
# + bitrate - For displaying a video preview or thumbnail, developers should use the “media_url” or “media_url_https”
#             values that point to an image.
# + url - The URL to the video file or playlist, depending on the content type.
public type VideoVariant record {
    string content_type;
    int bitrate?;
    string url;
};

# All Tweets with native media (photos, video, and GIFs) will include a set of ‘thumb’, ‘small’, ‘medium’,
# and ‘large’ sizes with height and width pixel sizes.
#
# + thumb - Information for a thumbnail-sized version of the media.
# + large - Information for a large-sized version of the media.
# + medium - Information for a medium-sized version of the media.
# + small - Information for a small-sized version of the media.
public type MediaSizes record {
    MediaSize thumb;
    MediaSize large;
    MediaSize medium;
    MediaSize small;
};

# Reprecent MediaSize object.
#
# + w - Width in pixels of this size.
# + h - Height in pixels of this size.
# + resize - Resizing method used to obtain this size. A value of fit means that the media was resized to fit
#            one dimension, keeping its native aspect ratio. A value of crop means that the media was cropped in order
#            to fit a specific resolution.
public type MediaSize record {
    int w;
    int h;
    string resize;
};

# The ExtendedEntities object contains a single media array of MediaEntity objects.
#
# + media - Array of MediaEntity object it contains media elements uploaded with the Tweet.
public type ExtendedEntities record {
    MediaEntity[] media;
};

# Search represents the result of a Tweet search.
#
# + statuses - A collection of Tweet object.
# + search_metadata - It describes a Search result.
public type Search record {
    Tweet[] statuses;
    SearchMetadata search_metadata;
};

# SearchMetadata describes a Search result.
#
# + count - The number of tweets returned per page.
# + since_id - From which TweetId you need to get the search result.
# + since_id_str - String representation of TweetId from which Tweet you need to get the search result.
# + max_id - Upto which TweetId you need to get the search result.
# + max_id_str - String representation of TweetId upto which Tweet you need to get the search result.
# + next_results - Returns a Hash of query parameters for the next result in the search.
# + completed_in - Time taken to complete the search.
# + query - Query string.
# + refresh_url - Returns a Hash of query parameters for the refresh URL in the search.
public type SearchMetadata record {
    int count;
    int since_id;
    string since_id_str;
    int max_id;
    string max_id_str;
    string next_results?;
    float completed_in;
    string query;
    string refresh_url;
};

# TrendsList represents a list of twitter trends.
#
# + trends - Collection of Trending objects.
# + as_of - Indicate the time or date from which trends list starts.
# + created_at - Created time.
# + locations - The locations associated with the trends.
public type TrendsList record {
    Trend[] trends;
    string as_of;
    string created_at;
    TrendsLocation[] locations;
};

# Representing Trend object.
#
# + name - Name of trend object.
# + url - URL of trend object.
# + promoted_content - Promoted content.
# + query - Query of the trend object.
# + tweet_volume - The tweet volume for the last 24 hours if available, -1 otherwise.
public type Trend record {
    string name;
    string url;
    string? promoted_content;
    string query;
    int? tweet_volume;
};

# TrendsLocation represents a twitter trend location.
#
# + name - Location name.
# + woeid - The Yahoo! Where On Earth ID of the location to return trending information for. Where On Earth IDentifier.
public type TrendsLocation record {
    string name;
    int woeid;
};

# Location represents a twitter Location.
#
# + country - Country name.
# + countryCode - Country code.
# + name - Name of the location.
# + parentid - Parent id of the location.
# + placeType - It represents a twitter trends PlaceType.
# + url - Location URL.
# + woeid - The Yahoo! Where On Earth ID of the location to return trending information for. Where On Earth IDentifier.
public type Location record {
    string country;
    string countryCode;
    string name;
    int parentid;
    PlaceType placeType;
    string url;
    int woeid;
};

# PlaceType represents a twitter trends PlaceType.
#
# + code - Location code of the place.
# + name - Name of the place.
public type PlaceType record {
    int code;
    string name;
};
