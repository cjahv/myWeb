var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var routes = require('./routes/index');
var app = express();
// app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());

app.use(/^.*?\.json$/, routes);

app.use("/public", function (req, res, next) {
    if (/^.*?\.(pug|less)$/.test(req.url) || req.url.indexOf("/view/model") === 0) {
        var err = new Error('Not Found');
        err.status = 401;
        next(err);
    } else next();
});

app.use("/public", express.static(path.join(__dirname, 'public')));

app.use("/", function (req, res, next) {
    res.redirect(301, "public/index.html");
});

app.use(function (req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

app.use(function (err, req, res, next) {
    res.status(err.status || 500);
    res.send(err.message);
});

module.exports = app;
