# Ballerina Twitter Connector Test

1. Create `ballerina.conf` file in `module-twitter`, with following keys and provide values for the variables.
    
```bash
CONSUMER_KEY="<Your Consumer Key>"
CONSUMER_SECRET="<Your Consumer Secret>"
ACCESS_TOKEN="<Your Access Token>"
ACCESS_TOKEN_SECRET="<Your Access Token Secret>"
```

2. Navigate to the folder `module-twitter` and run the test cases.

```bash
$ ballerina test twitter
```

The output will be similar to following:

```bash
Compiling source
        ldclakmal/twitter:0.10.0

Creating balos
        target/balo/twitter-2020r1-any-0.10.0.balo

Running Tests
        ldclakmal/twitter:0.10.0

        [pass] testTweet
        [pass] testRetweet
        [pass] testUnretweet
        [pass] testGetTweet
        [pass] testSearch
        [pass] testDeleteTweet

        6 passing
        0 failing
        0 skipped


Generating Test Report
        target/test_results.json

        View the test report at: file:///Users/ldclakmal/Projects/module-twitter/target/test_results.html
```