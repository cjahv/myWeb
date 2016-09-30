/**
 * Created by jahv on 2016/9/24.
 */
const $conn = require('../utils/dbConn');
const cache = require("../utils/cache");

module.exports = {
    getUser:function (name,fn) {
        $conn.select("select * from web_user where username = ? or email = ?",[name,name],function (data) {
            fn(data);
        })
    },
    item: function (id, fn) {
        $conn.select("select id,title,content,click,create_datetime,discuss from web_articles where id = ?", [id], function (data) {
            if (data !== null) {
                fn(data)
            }
        })
    },
    isExpire:function (id, stat,fn) {
        $conn.select("select create_datetime,change_datetime from web_articles where id = ?",[id],function (data) {
            data = data[0];
            var data_time = data.change_datetime;
            if(data.create_datetime>data.change_datetime) {
                data_time = data.create_datetime;
            }
            var file_time = stat.mtime;
            if(stat.ctime>stat.mtime) {
                file_time = stat.ctime;
            }
            fn(data_time>file_time)
        })
    },
    simple: function (id, fn, er) {
        var idWhere = id === 0 ? "" : " and id < ?";
        $conn.select(
            `select id,title,content,content_split,click,create_datetime,discuss\
                    from web_articles\
                    where parent_id is null${idWhere}\
                    order by id desc\
                    limit 5`,
            [id],
            function (data) {
                if (data !== null) {
                    for (var i = 0; i < data.length; i++) {
                        var split = data[i].content_split;
                        var content = data[i].content;
                        if (split) {
                            data[i].content = content.substring(0, split);
                            cache.set("article:other_content:" + data[i].id, content.substring(split));
                        }
                    }
                    fn(data)
                }
            })
    }
};