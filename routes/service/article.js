/**
 * Created by jahv on 2016/9/24.
 */
const _dao = require("../dao/article");
const cache = require("../utils/cache");

module.exports = {
    select: {
        article: {
            simple: function (req, res, next) {
                var id = parseInt(req.query.id);
                _dao.simple(id, function (data) {
                    res.send(data)
                });
            },
            remaining: function (req, res, next) {
                var id = parseInt(req.query.id);
                if (isNaN(id))next(error);
                else res.send(cache.get("article:other_content:" + id))
            }
        },
        login:{
            user:function (req, res, next) {
                res.send(req.session.user);
            },
            login:function (req, res, next) {
                req
            }
        }
    }
};