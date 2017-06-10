# CFESI
An ESI API wrapper for Eve Online written in CFML

Current version: 1.0.7

The EVEESIService CFC contains an API interface to the [Eve Online ESI API](https://esi.tech.ccp.is/latest/) - latest build: 2017-06-10

This code **does not** contain any Oauth interface (yet) nor does it do any error handling, this is left to the implementation of the API wrapper and not handled directly within the API wrapper itself.

This wrapper returns the result of the http call to the API. To get the data returned from the ESI API, use `serializeJSON( [apiResult].fileContent.toString() )`. For example:

```
  esi = new EVEESIService();
  
  allianceStruct = serializeJSON( esi.getAlliances().fileContent.toString() );
  
  writeDump( allianceStruct );
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
