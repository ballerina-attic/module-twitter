# Ballerina Twitter Connector Test

The Twitter connector allows you to tweet, retweet, untweet, and search for tweets through the Twitter REST API.
It handles OAuth 1.0a authentication. You can also retrieve and destroy a status, retrieve closest trend locations,
and top trends using the connector.

## Compatibility
| Ballerina Language Version | Twitter API version  |
| -------------------------- | -------------------- |
| 1.2.0                      | 1.1                  |


###### Running tests

1. Create `ballerina.conf` file in `module-twitter`, with following keys and provide values for the variables.
    
    ```.conf
    CLIENT_ID=""
    CLIENT_SECRET=""
    ACCESS_TOKEN=""
    ACCESS_TOKEN_SECRET=""
    ```
2. Navigate to the folder module-twitter

3. Run tests :

    ```ballerina
    ballerina init
    ballerina test twitter --config ballerina.conf
    ```
