# CFESI
An ESI API wrapper for Eve Online written in CFML

Current version: 1.0.8

The EVEESIService CFC contains an API interface to the [Eve Online ESI API](https://esi.tech.ccp.is/latest/) - latest build: 2017-06-10

This code is bundled with the EVESSOService CFC which provides functions to assist with getting OAuth 2.0 tokens from Eve Online for use with the API. Error handling in these CFC's are minimal, at best, and this is best left to the implementation of the API wrapper and not handled directly within the API wrapper itself.

The ESI API wrapper will check for a successful call (HTTP 200 OK) and will automatically parse the JSON results and return them. Any other status code will return the entire http result, including headers and other information for debug purposes.

The SSO wrapper will automatically parse the JSON results and return them. 


### Sample ESI Usage:

```
	esi = new EVEESIService();
  
	writeDump( esi.getAlliances() );
```


### Sample SSO Usage

Login Page:

```
	sso = new EVESSOService( clientId = '[YOUR CLIENT ID]', secretKey = '[YOUR SECRET KEY]', redirectURL = '[YOUR URL]' );

	<a href="#sso.getLoginURL()#">Login With Eve Online</a>
```

Callback:

```
	if( sso.hasCorrectState( URL.state ) ) {
		tokenStruct = sso.getAccessTokenByAuthCode( URL.code );
	}

	writeDump( tokenStruct );
```


## Compatibility

* Adobe ColdFusion 9+
* Lucee 4.5+


## Bugs and Feature Requests

If you find any bugs or have a feature you'd like to see implemented in this code, please use the issues area here on GitHub to log them.

## Contributing

This project is actively being maintained and monitored by Denard Springle. If you would like to contribute to this code base please feel free to fork, modify and send a pull request!

## License

The use and distribution terms for this software are covered by the Apache Software License 2.0 (http://www.apache.org/licenses/LICENSE-2.0).
