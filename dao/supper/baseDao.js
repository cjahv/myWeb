/**
 * Created by jahv on 2016/9/21.
 */
var $dbConn = require("./dbConn");

$dbConn.exec(function (err, conn) {

});

module.exports = {
    table_name:null,
    getInsert:function () {
        var table = module.exports.table_name;
        return "insert into "+table+" ";
    }
};