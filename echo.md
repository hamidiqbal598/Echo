# Echo - code challenge for back-end developers

## Task definition

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

### Terms

* *Echo* or *server*: it's what you are going to implement :)
* *mock endpoint*: the main purpose of Echo is to serve ephemeral/mock endpoints
  created with parameters specified by clients
* *Endpoints API*: a set of endpoints (`GET|POST|PATCH|DELETE /endpoints{/:id}`)
  designated to manage mock endpoints served by Echo. See examples in "Technical
  specifications" section

### Server requirements

* The server MUST implement `GET /endpoints` endpoint. The server MUST return a
  list of mock endpoints created by you, using `POST /endpoints` endpoint, or an
  empty array if no mock endpoints are defined yet. See examples in "Technical
  specifications" section.
* The server MUST implement `POST /endpoints` endpoint. The server creates a
  mock endpoint according to data from the payload. The server SHOULD validate
  received data. See examples in "Technical specifications" section.
* The server MUST implement `PATCH /endpoints{/:id}` endpoint. The server
  updates the existing mock endpoint according to data from the payload. The
  server SHOULD NOT accept invalid data or update non-existing mock endpoints.
  If requested mock endpoint doesn't exist, the server MUST respond with `404
  Not found`. See examples in "Technical specifications" section.
* The server MUST implement `DELETE /endpoints{/:id}` endpoint. The server
  deletes the requested mock endpoint. If requested mock endpoint doesn't exist,
  the server MUST respond with `404 Not found`. See examples in "Technical
  specifications" section.
* The server MUST serve mock endpoints as they defined by clients. Mock
  endpoints MUST be available over HTTP. All mock endpoints are available as
  they defined. Example: if there is a mock endpoint `POST /foo/bar/baz`, it
  MUST be available only for `POST` requests at `/foo/bar/baz` path. It SHALL
  NOT be available via `GET /foo/bar/baz` or even `POST /foo/bar` because these
  are different endpoints. Basically Echo works like "what you define is what
  you get".
* It's RECOMMENDED to validate incoming requests as might contain invalid data.
* The server MAY implement authentication for Endpoints API.
* You MAY implement additional functionality if you have time or will to show
  your skills.

### Solution requirements

* The programming language used to the solve the challenge MUST be Ruby
* You MAY use any framework to solve the challenge
* The server implementation SHALL NOT be provided without tests
* You MAY use any testing framework to write tests for your server
  implementation

Make sure you read and paid attention to recommendations and the technical
specification provided below.

## Recommendations

Proper and up-to-date documentation helps other people contribute to any
project. Make sure you deliver your project with well-written README and
annotated code (when it makes sense).

## How to deliver results?

It isn't necessary to deploy your solution anywhere. It's enough to send us a
link on *a public* repository on GitHub or GitLab. README should include
instructions on how to run and test the project on a local machine. Ideally, it
should only require a couple of commands to make the server up and running.

We will have Ruby and Bundler installed on our machines, so there is no need to
explain them.

##  Have questions?

In case something isn't clear or you have questions regarding the task, feel
free to contact us. Email address: <backend-interview@babbel.com>

## Technical specification

The server operates on _Endpoint_ entities:

    Endpoint {
      id    String
      verb  String
      path  String

      response {
        code    Integer
        headers Hash<String, String>
        body    String
      }
    }

  * `id` (required), a string value that uniquely identifies an Endpoint
  * `verb` (required), a string value that may take one of HTTP method names.
    See [RFC 7231](https://tools.ietf.org/html/rfc7231#section-4.3)
  * `path` (required), a string value of the path part of URL
  * `response` (required), an object with following attributes:
    * `code` (required), an integer status code returned by Endpoint
    * `headers` (optional), a key-value structure where keys represent HTTP
      header names and values hold actual values of these headers returned by
      Endpoint
    * `body` (optional), a string representation of response body returned by
      Endpoint

You are free to extend the list of attributes if your implementation requires
that. The list above represents what the entity should have as minimum.

Echo serves mock endpoints as they previously defined by the clients via
Endpoints API. For example it will serve `{ "message": "Hello world" }` as
response from `GET /foo/bar` endpoint, if this endpoint was defined upfront via
Endpoints API.

### Format

To prevent bikeshedding and possibly save your time, Endpoints API uses
[JSON:API v1.0](https://jsonapi.org/) as a format. However you are free to use
another format. If you decide to go with a format different to JSON:API v1.0,
make sure to document that in README to help us during evaluation.

### Examples

<details>
  <summary>List endpoints</summary>
  <markdown>
#### Request

    GET /endpoints HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": [
            {
                "type": "endpoints",
                "id": "12345",
                "attributes": [
                    "verb": "GET",
                    "path": "/greeting",
                    "response": {
                      "code": 200,
                      "headers": {},
                      "body": "\"{ \"message\": \"Hello, world\" }\""
                    }
                ]
            }
        ]
    }
  </markdown>
</details>

<details>
  <summary>Create endpoint</summary>
  <markdown>
#### Request

    POST /endpoints HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### Expected response

    HTTP/1.1 201 Created
    Location: http://example.com/greeting
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }
  </markdown>
</details>

<details>
  <summary>Update endpoint</summary>
  <markdown>
#### Request

    PATCH /endpoints/12345 HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345"
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }


#### Expected response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }
  </markdown>
</details>

<details>
  <summary>Delete endpoint</summary>
  <markdown>
#### Request

    DELETE /endpoints/12345 HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 204 No Content
  </markdown>
</details>

<details>
  <summary>Error response</summary>
  <markdown>
In case client makes unexpected response or server encountered an internal
problem, Echo should provide proper error response.

#### Request

    DELETE /endpoints/1234567890 HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested Endpoint with ID `1234567890` does not exist"
            }
        ]
    }
  </markdown>
</details>

<details open>
  <summary>Sample scenario</summary>
  <markdown>

#### 1. Client requests non-existing path

    > GET /hello HTTP/1.1
    > Accept: application/vnd.api+json

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested page `/hello` does not exist"
            }
        ]
    }

#### 2. Client creates an endpoint

    > POST /endpoints HTTP/1.1
    > Content-Type: application/vnd.api+json
    > Accept: application/vnd.api+json
    >
    > {
    >     "data": {
    >         "type": "endpoints",
    >         "attributes": {
    >             "verb": "GET",
    >             "path": "/hello",
    >             "response": {
    >                 "code": 200,
    >                 "headers": {
    >                     "Content-Type": "application/json"
    >                 },
    >                 "body": "\"{ \"message\": \"Hello, world\" }\""
    >             }
    >         }
    >     }
    > }

    HTTP/1.1 201 Created
    Location: http://example.com/hello
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/hello",
                "response": {
                    "code": 200,
                    "headers": {
                        "Content-Type": "application/json"
                    },
                    "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### 3. Client requests the recently created endpoint

    > GET /hello HTTP/1.1
    > Accept: application/json

    HTTP/1.1 200 OK
    Content-Type: application/json

    { "message": "Hello, world" }

#### 4. Client requests the endpoint on the same path, but with different HTTP verb

The server responds with HTTP 404 because only `GET /hello` endpoint is defined.

NOTE: if you could imagine different behavior from the server, feel free
to propose it in your solution.

    > POST /hello HTTP/1.1
    > Accept: application/vnd.api+json

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested page `/hello` does not exist"
            }
        ]
    }

  </markdown>
</details>

## Version

1.0.1
