var restify = require('restify');

var PORT=8080

function respond(req, res, next) {
  res.send('hello ' + req.params.name + '!');    
}

var server=restify.createServer();
server.get('/hello/:name', respond);
server.head('/hello/:name', respond);

server.listen(PORT, function() {
  console.log('%s listening at %s', server.name, server.url);
});
