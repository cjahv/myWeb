var express = require('express');
var router = express.Router();

var $conn = require('../utils/dbConn');

/* GET home page. */
router.get('/', function (req, res, next) {
    // $conn.exec(function (conn) {
    //     conn.query("select `key`,value from web_config where `key` like 'web.%'", function (err, rows, fields) {
    //         if (err === null) {
    //             var data = {};
    //             for (var i = 0; i < rows.length; i++) {
    //                 var row = rows[i];
    //                 data[row.key.split('.')[1]] = row.value;
    //             }
    //             res.render('index', data);
    //         }
    //     });
    // })
    res.send("1");
});

module.exports = router;
