/*
A simple Hello World host in Node.js

Response text is generated in JSON format for every request. 

Created in 2014 by Radek Tomasek / Seal Teaks Ltd.
*/

var http = require('http');

var json_content = {
	message: "Hello world"	
};

http.createServer(function(request, response){
	response.writeHead(200, {'Content-Type': 'text/json'});
	response.write(JSON.stringify(json_content));
	response.end()
}).listen(1337, '127.0.0.1');

console.log("Running Node.js host...");