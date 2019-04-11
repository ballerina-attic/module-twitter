[![Build Status](https://travis-ci.org/wso2-ballerina/module-twitter.svg?branch=master)](https://travis-ci.org/wso2-ballerina/module-twitter)

# Ballerina Twitter Client

The Twitter client allows you to create Tweets, reply to a Tweet, Retweets, Likes a Tweet, search Tweets, retrieve timeline Tweets, and retrieve mentions for the user through the Twitter REST API. You can also retrieve followers for the specified user, retrieve closest trend locations, and top trends using this client.


## Compatibility
|                    |    Version     |
|:------------------:|:--------------:|
| Ballerina Language |   0.991.0      |
| Twitter API        |   1.1          |


## Download and install

### Download the module

You can pull the Twitter client from Ballerina Central:

```shell
$ ballerina pull wso2/twitter
```

### Install from source

Alternatively, you can install Twitter client from the source using the following instructions.

**Building the source**

1. Clone this repository using the following command:

    ```shell
    $ git clone https://github.com/wso2-ballerina/module-twitter.git
    ```

2. Run this command from the `module-twitter` root directory:

    ```shell
    $ ballerina build twitter
    ```

**Installation**

You can install `module-twitter` using:

```shell
$ ballerina install twitter
```


## Running Tests

1. Create `ballerina.conf` file in `module-twitter` with following configurations and provide appropriate value.

    ```
    CLIENT_ID=""
    CLIENT_SECRET=""
    ACCESS_TOKEN=""
    ACCESS_TOKEN_SECRET=""
    ```

2. Navigate to the `module-twitter` directory.

3. Run tests :

    ```ballerina
    ballerina init
    ballerina test twitter --config ballerina.conf
    ```


## How you can contribute

As an open source project, we welcome contributions from the community. Check the [issue tracker](https://github.com/wso2-ballerina/module-twitter/issues) for open issues that interest you. We look forward to receiving your contributions.
