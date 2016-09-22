/**
 * Created by jahv on 2016/9/21.
 */
// 实现与MySQL交互
var mysql = require('mysql');
var $db_conf = require('../conf/db');

// 使用连接池，提升性能
var pool = mysql.createPool($db_conf.mysql);

module.exports = {
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
    exec: function (callback) {
        pool.getConnection(function (err, connection) {
            if (!!err) {
                console.error("dbError:" + err);
            } else if ("function" === typeof callback) {
                // connection.connect();
                callback(connection);
                connection.release();
            }
        });
    }
};