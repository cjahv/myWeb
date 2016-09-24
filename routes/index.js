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

var error = new Error("server error!");
error.statusCode = 500;

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

var cache = {
    val:{},
    get:function (key) {
        return cache.val[key];
    },
    set:function (key, val) {
        return cache.val[key] = val;
    }
};

var _action = {
    select: {
        article: {
            simple: function (req, res, next) {
                var id = req.query.id;
                _dao.select("select id,title,content,content_split,click,create_datetime,discuss \
                    from web_articles \
                    where parent_id is null and id > ?\
                    limit 5",
                    [id],
                    function (data) {
                        if (data !== null) {
                            for (var i = 0; i < data.length; i++) {
                                var split = data[i].content_split;
                                var content = data[i].content;
                                if(split) {
                                    data[i].content = content.substring(0, split);
                                    cache.set("article:other_content:" + data[i].id, content.substring(split));
                                }
                            }
                            res.send(data)
                        }
                    })
            },
            remaining:function (req, res, next) {
                var id=parseInt(req.query.id);
                if(isNaN(id))next(error);
                else res.send(cache.get("article:other_content:" + id))
            }
        }
    }
};

module.exports = function (req, res, next) {
    var action = req.baseUrl.substring(req.baseUrl.lastIndexOf('/')+1, req.baseUrl.lastIndexOf('.'));
    eval('_action.' + action + '(req,res,next)');
};
