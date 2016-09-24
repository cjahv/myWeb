var _action = require("./service/article");

var error = new Error("server error!");
error.statusCode = 500;

module.exports = function (req, res, next) {
    var action = req.baseUrl.substring(req.baseUrl.lastIndexOf('/')+1, req.baseUrl.lastIndexOf('.'));
    eval('_action.' + action + '(req,res,next)');
};
