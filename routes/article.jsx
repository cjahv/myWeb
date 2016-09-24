/**
 * Created by jahv on 2016/9/24.
 */
const fs = require('fs');
const path = require('path');
const pug = require("pug");
const indexPug = pug.compileFile("public/index.pug");
const articleDao = require("./dao/article");
const moment = require("moment");

module.exports = function (req, res, next) {
    fs.exists(req.baseUrl.substr(1), function (d) {
        var id = parseInt(req.params.id);
        if(isNaN(id))return res.end();
        function create() {
            articleDao.item(id, function (data) {
                data[0].create_datetime = moment(data[0].create_datetime).format("YYYY-MM-DD");
                var html = indexPug({
                    title: `${data[0].title} - 郝都闲人`,
                    description: "",
                    article: "article",
                    data: data,
                });
                if (!fs.existsSync("public/article")) {
                    fs.mkdirSync("public/article", 0o755);
                }
                fs.writeFile(req.baseUrl.substr(1), html, function (e) {
                    if (e)throw e;
                    res.sendFile(path.join(__dirname, "..", req.baseUrl));
                })
            });
        }
        if(!d) {
            create();
        }else{
            var _path = path.join(__dirname, "..", req.baseUrl);
            var stat = fs.statSync(_path);
            articleDao.isExpire(id,stat,function (expire) {
                if (expire) {
                    create();
                } else {
                    res.sendFile(_path);
                }
            })
        }
    })
};