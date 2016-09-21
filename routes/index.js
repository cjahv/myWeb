var express = require('express');
var router = express.Router();

var $conn = require('../dao/dbConn');

/* GET home page. */
router.get('/', function(req, res, next) {
    $conn.exec(function (conn) {
        conn.query();
        res.render('index', { title: 'Express' });
    })
});

module.exports = router;
