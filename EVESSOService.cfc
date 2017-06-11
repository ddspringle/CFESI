/**
*
* @file  EVESSOService.cfc
* @author  Denard Springle (denard.springle@gmail.com)
* @description I provide a CFC interface for the Eve Online SSO OAuth2
*
*/

component displayname="EVESSOService" accessors="true" {

	property clientId;
	property secretKey;
	property redirectURL;
	property loginURL;
	property tokenURL;
	property userAgent;
	property scopes;

	/**
	* @displayname	init
	* @description	I am the components constructor
	* @param		clientId {String} required - I am the client id for your application, provided at https://developers.eveonline.com/applications/ 
	* @param		secretKey {String} required - I am the secret key for your application, provided at https://developers.eveonline.com/applications/
	* @param 		redirectURL {String} required - I am the redirect url you registered with your application
	* @param 		loginURL {String} - I am the base url used for SSO logins. Default: https://login.eveonline.com/oauth/authorize/
	* @param 		tokenURL {String} - I am the base url used for SSO tokens. Default: https://login.eveonline.com/oauth/token
	* @param 		userAgent {String} - I am the user agent string to send to CCP (should include char name, email and host information)
	* @param 		scopes {String} - I am a space delimited list of ESI scopes to request access to from the user. Default: all of them :P
	*/
	public function init( 
		required string clientId,
		required string secretKey,
		required string redirectURL,
		string loginURL = 'https://login.eveonline.com/oauth/authorize/',
		string tokenURL = 'https://login.eveonline.com/oauth/token',
		string userAgent = 'CFESI v1.0 (author: Silly Noob - denard.springle@gmail.com) [host: http://#CGI.HTTP_HOST#/]',
		string scopes = 'esi-calendar.respond_calendar_events.v1 esi-calendar.read_calendar_events.v1 esi-location.read_location.v1 esi-location.read_ship_type.v1 esi-mail.organize_mail.v1 esi-mail.read_mail.v1 esi-mail.send_mail.v1 esi-skills.read_skills.v1 esi-skills.read_skillqueue.v1 esi-wallet.read_character_wallet.v1 esi-search.search_structures.v1 esi-clones.read_clones.v1 esi-characters.read_contacts.v1 esi-universe.read_structures.v1 esi-bookmarks.read_character_bookmarks.v1 esi-killmails.read_killmails.v1 esi-corporations.read_corporation_membership.v1 esi-assets.read_assets.v1 esi-planets.manage_planets.v1 esi-fleets.read_fleet.v1 esi-fleets.write_fleet.v1 esi-ui.open_window.v1 esi-ui.write_waypoint.v1 esi-characters.write_contacts.v1 esi-fittings.read_fittings.v1 esi-fittings.write_fittings.v1 esi-markets.structure_markets.v1 esi-corporations.read_structures.v1 esi-corporations.write_structures.v1 esi-characters.read_loyalty.v1 esi-characters.read_opportunities.v1 esi-characters.read_chat_channels.v1 esi-characters.read_medals.v1 esi-characters.read_standings.v1 esi-characters.read_agents_research.v1 esi-industry.read_character_jobs.v1 esi-markets.read_character_orders.v1 esi-characters.read_blueprints.v1 esi-characters.read_corporation_roles.v1 esi-location.read_online.v1'
	) {
		variables.clientId = arguments.clientId;
		variables.secretKey = arguments.secretKey;
		variables.redirectURL = arguments.redirectURL;
		variables.loginURL = arguments.loginURL;
		variables.tokenURL = arguments.tokenURL;
		variables.userAgent = arguments.userAgent;
		variables.scopes = arguments.scopes;

		return this;
	}

	/**
	* @displayname	getLoginURL
	* @description	I am a convenience function used to generate the URL users are directed to to login to EvE SSO
	* @return		string
	*/
	public string function getLoginUrl() {
		return variables.loginURL & '?response_type=code&redirect_uri=' & encodeForUrl( variables.redirectURL ) & '&client_id=' & variables.clientId & '&scope=' & encodeForUrl( variables.scopes ) & '&state=' & hash( getIPAddress(), 'MD5', 'UTF-8', 1024 );
	}

	/**
	* @displayname	hasCorrectState
	* @description	I confirm the state returned from SSO login matches the expected state
	* @param 		state {String} required - I am the state string returned from the SSO login
	* @return		boolean
	*/
	public boolean function hasCorrectState( required string state ) {
		return findNoCase( arguments.state, hash( getIPAddress(), 'MD5', 'UTF-8', 1024 ) );
	}

	/**
	* @displayname	getAccessTokenByAuthCode
	* @description	I get an access token from the auth code returned from the SSO login
	* @param 		authCode {String} required - I am the auth code returned from the SSO login
	* @return		struct
	*/
	public struct function getAccessTokenByAuthCode( required string authCode ) {

		// get the http service
		var httpService = new http();
		var apiResult = '';

		// set the url
		httpService.setUrl( variables.tokenURL );
		// set the method
		httpService.setMethod( 'POST' );
		// set the character set
		httpService.setCharset( 'UTF-8' );
		// set the user agent string
		httpService.setUserAgent( variables.userAgent );
		// set username for Basic auth
		httpService.setUsername( variables.clientId );
		// set the password for Basic auth
		httpService.setPassword( variables.secretKey );

		// add form field parameters to the http request
		httpService.addParam( name = 'grant_type', type = 'formfield', value = 'authorization_code' );
		httpService.addParam( name = 'code', type = 'formfield', value = arguments.authCode );

		// make the http call
		apiResult = httpService.send().getPrefix();

		// return the parsed results
		return serializeJSON( apiResult.fileContent.toString() );

	}

	/**
	* @displayname	getAccessTokenByRefresh
	* @description	I get an access token from the refresh token stored for this user
	* @param 		refreshToken {String} required - I am the refresh token stored for this user
	* @return		struct
	*/
	public struct function getAccessTokenByRefresh( required string refreshToken ) {

		// get the http service
		var httpService = new http();
		var apiResult = '';

		// set the url
		httpService.setUrl( variables.tokenURL );
		// set the method
		httpService.setMethod( 'POST' );
		// set the character set
		httpService.setCharset( 'UTF-8' );
		// set the user agent string
		httpService.setUserAgent( variables.userAgent );
		// set username for Basic auth
		httpService.setUsername( variables.clientId );
		// set the password for Basic auth
		httpService.setPassword( variables.secretKey );

		// add form field parameters to the http request
		httpService.addParam( name = 'grant_type', type = 'formfield', value = 'refresh_token' );
		httpService.addParam( name = 'refresh_token', type = 'formfield', value = arguments.refreshToken );

		// make the http call
		apiResult = httpService.send().getPrefix();

		// return the parsed results
		return serializeJSON( apiResult.fileContent.toString() );
		
	}

	/**
	* @displayname	getIPAddress
	* @description	I am a private convenience function used to return the IP address of the client
	* @return		string
	*/
	private string function getIPAddress() {

		// get the http request headers
		var headers = getHTTPRequestData().headers;

		// check if this server sits behind a load balancer, proxy or firewall
		if( structKeyExists( headers, 'x-forwarded-for' ) ) {
			// it does, return the ip address this request has been forwarded for
			return headers[ 'x-forwarded-for' ];
		// otherwise
		} else {
			// it doesn't, return the ip address of the remote client
			return CGI.REMOTE_ADDR;
		}
	}

}