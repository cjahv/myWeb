/**
 * Created by jahv on 2016/9/22.
 */
var Web = {
    generate: {
        article: function (data) {
            var article = this.clone().removeClass("hide");
            article.find(".title").text(data.title);
            article.find("time").text(data.create_datetime.substring(0, data.create_datetime.indexOf('T')))
                .attr("datetime", data.create_datetime);
            article.find(".post-comments-count").text(data.discuss);
            article.find(".leancloud-visitors-count").text(data.click);
            article.find(".post-body").html(data.content);
            if (!data.content_split)article.find(".post-more-link").remove();
            article.data("id", data.id);
            return article.attr("id", "article-" + data.id);
        }
    },
    getLogin: function (fn) {
        var user = Cache.get("web:user");
        if (!user) {
            $.get("select.login.user.json", function (data) {
                if (!data) {
                    fn(false)
                } else {
                    Cache.set("web:user", data);
                    fn(data);
                }
            })
        } else {
            fn(user);
        }
    },
    login: function (url) {
        Web.getLogin(function (user) {
            if (!user) {

            } else {
                location.href = url;
            }
        })
    },
    changeUrl: function (url, search, title) {
        if (/^(https?:)?\/\/.*/.test(url))return;
        var path = location.pathname;
        if (url.indexOf("?") > 0) {
            var urls = url.split("?", 2);
            url = urls[0];
            if (search !== false)search = "?" + urls[1];
        }
        if (url.charAt(0) == "/") {
            path = url;
        } else {
            var x = url.split("/");
            var p = path.split("/");
            delete p[0];
            delete p[p.length - 1];
            var len = p.length;
            for (var i = 0; i < x.length; i++) {
                if (x[i] === "..") {
                    for (var j = len - 1; j >= 0; j--) {
                        if (p[j] !== undefined) {
                            delete p[j];
                            break;
                        }
                    }
                } else if (x[i] !== ".") {
                    p[len++] = x[i];
                }
            }
            var tmp = [];
            for (i = 0; i < len; i++) {
                if (p[i] !== undefined) {
                    tmp.push(p[i]);
                }
            }
            path = "/" + tmp.join("/");
        }
        var origin = location.origin;
        if (!origin) {
            origin = location.protocol + "//" + location.host;
        }
        if (search !== false && !search) {
            search = location.search;
        }
        var href = origin + path;
        if (search) {
            href += search;
        }
        window.history.pushState({}, title, href)
    }
};

var Cache = {
    _value: {},
    get: function (key) {
        return Cache._value[key];
    },
    set: function (key, value) {
        return Cache._value[key] = value;
    }
};