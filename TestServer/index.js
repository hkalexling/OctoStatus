var express = require('express');
var app = express();
var http = require('http').Server(app);
var fs = require('fs');

var ip = 'http://192.168.1.161:8000';

var response_ary = [
{
	'status': 'good',
	'body': 'Battlestation fully operational',
	'created_on': '2012-12-07T18:11:55Z'
},
{
	'status': 'minor',
	'body': 'GitHub Pages is serving all sites as expected but some 404 responses may continue to be cached for up to 30 minutes.',
	'created_on': '2012-12-07T18:11:55Z'
},{
	'status': 'major',
	'body': 'Major service outage.',
	'created_on': '2012-12-07T18:11:55Z'
}];

app.get('/api.json', function(req, res){
	return res.json({
		'status_url': ip + '/status.json',
		'messages_url': ip + '/messages.json',
		'last_message_url': ip + '/last-message.json'
	});
});

app.get('/last-message.json', function(req, res){
	fs.readFile('source', 'utf8', function(error, data){
		var response = response_ary[0];
		if (data){
			var num = parseInt(data);
			response = response_ary[num];
		}
		return res.json(response);
	});
});

http.listen(8000, function(){
	console.log('listening to port 8000');
});