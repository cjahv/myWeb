/**
 * Created by jahv on 2016/9/24.
 */
const dao = require("../dao/article");
const cache = require("../utils/cache");
const userUtil = require("../utils/user");

module.exports = {
    select: {
        article: {
            simple: function (req, res, next) {
                var id = parseInt(req.query.id);
                dao.simple(id, function (data) {
                    res.send(data)
                });
            },
            remaining: function (req, res, next) {
                var id = parseInt(req.query.id);
                if (isNaN(id))next(new Error("文章id无效"));
                else res.send(cache.get("article:other_content:" + id))
            }
        },
        login: {
            user: function (req, res, next) {
                res.send(req.session.user);
            },
            login: function (req, res, next) {
                var name = req.body.name;
                var pass = req.body.pass;
                dao.getUser(name, function (user) {
                    pass = userUtil.getPassword(pass);
                    if (pass === user.password) {
                        user.password = "******";
                        req.session.user = user;
                        res.send({error: false, user: user});
                    } else {
                        res.send({error: true, msg: "用户名或密码错误"});
                    }
                });
            }
        }
    }
};