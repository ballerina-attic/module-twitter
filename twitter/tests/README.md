# Ballerina Twitter Connector Test

The Twitter connector allows you to access the Twitter REST API through ballerina. The following section provide you the details on how to use Ballerina 
Twitter connector.

## Compatibility
| Ballerina Language Version | Twitter API version  |
| ------------- | ----- |
| 0.970.0-beta13 | 1.1 |


###### Running tests

1. Create `ballerina.conf` file in `package-twitter`, with following keys and provide values for the variables.
    
    ```.conf
    CLIENT_ID=""
    CLIENT_SECRET=""
    ACCESS_TOKEN=""
    ACCESS_TOKEN_SECRET=""
    ```
2. Navigate to the folder package-twitter

3. Run tests :

    ```
    ballerina init
    ballerina test twitter --config ballerina.conf
   ```
