# Ballerina Twitter Connector Test

The Twitter connector allows you to access the Twitter REST API through ballerina. And the Twitter connector actions 
are being invoked with a ballerina main function. The following section provide you the details on how to use Ballerina 
Twitter connector.

## Compatibility
| Language Version        | Connector Version          | Twitter API version  |
| ------------- |:-------------:| -----:|
| 0.970.0-alpha4 | 0.8 | 1.1 |


###### Running tests

1. Create `ballerina.conf` file in `package-twitter`, with following keys and provide values for the variables.

```.conf
CLIENT_ID=""
CLIENT_SECRET=""
ACCESS_TOKEN=""
ACCESS_TOKEN_SECRET=""
```

2. Run tests :
```ballerina test twitter``` from your connector directory.
