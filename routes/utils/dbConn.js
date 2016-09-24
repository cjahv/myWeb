/**
 * Created by jahv on 2016/9/21.
 */
// 实现与MySQL交互
var mysql = require('mysql');
var $db_conf = require('../conf/db');

// 使用连接池，提升性能
var pool = mysql.createPool($db_conf.mysql);

/**
 * This callback type is called `requestCallback` and is displayed as a global symbol.
 *
 * @callback getConnectionCallback
 * @param {PoolConnection} connection
 */

/**
 * 获取conn
 * @param {getConnectionCallback} callback
 */
var exec = function (callback) {
    pool.getConnection(function (err, connection) {
        if (!!err) {
            console.error("dbError:" + err);
        } else if ("function" === typeof callback) {
            // connection.connect();
            callback(connection);
            connection.release();
        }
    });
};

module.exports = {
    select: function (sql, values, fn) {
        if (typeof values === "function") {
            fn = values;
            values = null;
        }
        exec(function (conn) {
            console.log("SQL " + sql.replace(/ +/g, ' ') + "; " + JSON.stringify(values));
            conn.query(sql, values, function (err, rows, fields) {
                fn(err || rows)
            });
        })
    }
};