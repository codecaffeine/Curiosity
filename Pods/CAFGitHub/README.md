# CAFGitHub
A simple GitHub library for Cocoa


## Requirements
- iOS 6.0+
- AFNetowrking 1.0
- Mantle 0.2


## Goals
### Confidence
To be confident in the code, and confident in changing code. Yes, this means ‘unit testing’


## Design

### CAFUser
- User Object.

### CAFGist
- Gist object

### CAFGistClient
- Network access to retrieve Gists
- Optional User object for authentication

envision:
```obj-c
[cafGitClient requestPublicGistsWithCompletion:^(NSArray *gists, NSError *error){
	if (gists) {
		NSLog(@"gists: %@", gists);
	}
}];

[cafGitClient getGistForUsername:(NSString *)username
                      completion:^(NSArray *gists, NSError *error){
	NSLog(@"gists: %@", gists);
}];

[cafGitClient getGistsWithCompletion:^(NSArray *gists, NSError *error){
	NSLog(@"gists: %@", gists);
}];

[cafGitClient getGistsWithID:(NSUInteger)gistID 
                  completion:^(CAFGist *gist, NSError *error){
	NSLog(@"gist: %@", gist);
}];
```


- Can there ever be a situation where there are nil gists and no error?
  - Assumption: There shouldn't be
  - Should we return an empty array rather than nil if there are no gists but no errors?


## TODO
- Parse User
- Pagination
- Handle Error
  - Example:

```
2012-12-22 08:43:04.378 CAFGitHub[723:c07] error: Error Domain=AFNetworkingErrorDomain Code=-1011 "Expected status code in (200-299), got 502" UserInfo=0x754a6a0 {NSLocalizedRecoverySuggestion={
  "message": "Server Error"
}
, AFNetworkingOperationFailingURLRequestErrorKey=<NSMutableURLRequest https://api.github.com/gists/public>, NSErrorFailingURLKey=https://api.github.com/gists/public, NSLocalizedDescription=Expected status code in (200-299), got 502, AFNetworkingOperationFailingURLResponseErrorKey=<NSHTTPURLResponse: 0x8112ce0>}
```