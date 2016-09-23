// var express = require('express');
// var router = express.Router();

var $conn = require('../utils/dbConn');

// /* GET home page. */
// router.get('/', function (req, res, next) {
//     // $conn.exec(function (conn) {
//     //     conn.query("select `key`,value from web_config where `key` like 'web.%'", function (err, rows, fields) {
//     //         if (err === null) {
//     //             var data = {};
//     //             for (var i = 0; i < rows.length; i++) {
//     //                 var row = rows[i];
//     //                 data[row.key.split('.')[1]] = row.value;
//     //             }
//     //             res.render('index', data);
//     //         }
//     //     });
//     // })
//     res.send("1");
// });

var _dao = {
    select: function (sql, values, fn) {
        if (typeof values === "function") {
            fn = values;
            values = null;
        }
        $conn.exec(function (conn) {
            console.log("SQL "+sql.replace(/ +/g,' ')+"; "+JSON.stringify(values));
            conn.query(sql, values, function (err, rows, fields) {
                fn(err || rows)
            });
        })
    }
};

var _action = {
    select: {
        article: {
            simple: function (req, res, next) {
                var page = req.query.page;
                var start = page * 5 - 5;
                _dao.select("select id,title,content,click,create_datetime,discuss \
                    from web_articles \
                    where parent_id is null \
                    order by create_datetime desc limit ?,5",
                    [start],
                    function (data) {
                        if (data !== null) {
                            res.send(data)
                        }
                    })
            }
        }
    }
};

module.exports = function (req, res, next) {
    var action = req.baseUrl.substring(1, req.baseUrl.lastIndexOf('.'));
    eval('_action.' + action + '(req,res,next)');
};
