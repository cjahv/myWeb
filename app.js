const express = require('express');
const path = require('path');
const favicon = require('serve-favicon');
const logger = require('morgan');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const bodyParser = require('body-parser');
const app = express();
app.use(favicon(path.join(__dirname, 'public', 'images', 'favicon.png')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());
app.use(session({
    resave: false,
    saveUninitialized: true,
    secret: 'x5KoQx7l0q4L6IDFq7ihKdnHkhcwiBeH5FnPMGP8vH4rb3ir1vetz1CYefCLV5Loa5iBZGouLRwFzeMJmrJ5vFdfz22mgFhGXLk74ZLe3CdVg2IeMaGXVAjxuVH8x71n',
    cookie: {maxAge: 1800000}
}));

app.use("**.json", require('./routes/index'));

app.use("/public/article/:id.html", require('./routes/article.jsx'));

app.use("/public", function (req, res, next) {
    if (req.url.indexOf("/admin/") >= 0 && (!req.session.user || req.session.user.auth < 200)
        || req.url.indexOf("/view/") === 0
        || /^.*?\.(pug|less)$/.test(req.url)) {
        var err = new Error('Not Auth');
        err.status = 401;
        next(err);
    } else next();
});

app.use("/public", express.static(path.join(__dirname, 'public')));

app.use("/", function (req, res, next) {
    if (req.url === "/")res.redirect(301, "public/index.html");
    else next();
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
