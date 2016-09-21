/**
 * Created by jahv on 2016/9/21.
 */
// 实现与MySQL交互
var mysql = require('mysql');
var $db_conf = require('../../conf/db');

// 使用连接池，提升性能
var pool  = mysql.createPool($db_conf.mysql);

module.exports = {
    exec: function (callback) {
        pool.getConnection(function(err, connection) {
            if("function"===typeof callback) {
                callback(err, connection);
                connection.release();
            }
        });
    }
};