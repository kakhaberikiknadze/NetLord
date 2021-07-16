# NetLord

**NetLord** is a swift package specifically for Networking purposes.

## Architecture

<img width="1299" alt="Screenshot 2021-07-16 at 15 28 19" src="https://user-images.githubusercontent.com/79094816/125940838-f9dc6473-3d0f-4995-88d3-8b0ad0c209a1.png">


### General flow of API call

![](./Docs/NetworkingFlowDiagram.png)

### Network Manager

`NetworkManager` is responsible for performing provided request. In case it needs an authorization and has an `authorizer`, network manager triggers `authorizer`'s `authorize()` method and only after that it calls actual `perform` method with an authorized request. Same thing applies on `dataTask` and `downloadTask`. 

> Currently `NetworkManager` doesn't contain an `uploadTask`.

You can initialize `NetworkManager` with `NetworkTaskProviding` abstraction (**Required**) e.g. `URLSession`, authorizer(*Optional*) and `decoder`(*Optional*).

```swift
let session = URLSession(configuration: .default)
let authorizer = NetworkRequestAuthorizer(tokenStore: MyTokenStore(), configuration: .default, tokenRefresher: MyTokenRefresher())
let manager = NetworkManager(session: session, authorizer: authorizer, decoder: JSONDecoder())
```

### Authorizing

`Authorizing` is an abstraction for authorizer containing `isSignedIn` property alongside `authorize()` method.

```Swift
public protocol Authorizing: AnyObject {
    var isSignedIn: Bool { get }
    func authorize() -> AnyPublisher<HTTPHeaders, Error>
}
```

> You can use `NetworkRequestAuthorizer` for authorizer or implement your own one.

### NetworkRequestAuthorizer

`NetowrkRequestAuthorizer` is an implementation of `Authorizing` and is responsible for authorizing network request. It needs to have a token store from where it fetches an access token. If token's not found or expired then authorizer tries to fetch a refresh token from which it would ask token refresher to refresh the token. In case refresh token is also not found or outdated then it throws an error.

You can initialize it with `TokenStoring` (abstraction used for handling token persistence), `Configuration` and `TokenRefreshHandler` block or it has another initializer with `TokenStoring`, `Configuration` and `TokenRefreshing`.

```swift
let authorizer = NetworkRequestAuthorizer(tokenStore: MyTokenStore(), configuration: .default, tokenRefresher: MyTokenRefresher())

// OR

let authorizer = NetworkRequestAuthorizer(
    tokenStore: MyTokenStore(),
    configuration: .default,
    tokenRefreshBlock: myRefreshBlock
)
```

### TokenStoring

`TokenStoring` is a protocol containing methods for storing, getting and removing tokens in a persistence store. (e.g. Keychain).

### Endpoint

`Endpoint` is a structure containing request method, path and query items.

### Request Builder

`RequestBuilder` is a builder for `URLRequest`. You can build it by setting scheme, host, base path, endpoint and additional headers.

## Example of API call

```Swift
let session = URLSession(configuration: .default)
let authorizer = NetworkRequestAuthorizer(tokenStore: MyTokenStore(), tokenRefresher: MyTokenRefresher())
let manager = NetworkManager(session: session, authorizer: authorizer, decoder: JSONDecoder())

let queries: [URLQueryItem] = [.init(name: "foo", value: "bar")]
let endpoint = Endpoint(path: "my/path", queryItems: queries)
let request = RequestBuilder()
            .setScheme("https")
            .setHost("example.com")
            .setBasePath("/v1")
            .setEndpooint(endpoint)
            .build()
return manager.perform(request: request)
```
Or you can also use `NetworkManager`'s function builder approach for building request and performing it this way:

```Swift
manager.makeRequest {
            Scheme("https")
            Host("example.com")
            URLPath("my/path")
            // And more ...
        }
        .dataTaskPublisher(responseType: Dummy.self)
        .sink { result in
            // Handle result here
        } receiveValue: { value in
            // Handle output here
        }
        .store(in: &cancellables)
```

## More
For more documentation please refer to [NetLord wiki page](https://github.com/kakhaberikiknadze/NetLord/wiki)
