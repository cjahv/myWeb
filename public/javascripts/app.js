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
            $("body>.container").addClass("hide");
            if (!user) {
                $(".user>.login-box").removeClass("hide");
                var $loginForm = $("#login-form").ajaxForm({
                    success: function (data) {
                        if (data.error) {
                            $loginForm.find(".error-msg").text(data.msg);
                        } else {
                            Cache.set("web:user", data.user);
                            Web.loadView(url);
                        }
                    }
                });
            } else {
                Web.loadView(url);
            }
        })
    },
    loadView: function (url) {
        var view = Cache.get("web:view:exist:" + url);
        if (!view) {
            $.get(url, function (view) {
                Cache.set("web:view:" + url, view);
                Cache.set("web:view:exist:" + url, true);
                Cache.set("web:view:id:index", function (value) {
                    return value ? ++value : 1;
                });
                Web.drawView(url);
            })
        } else {
            Web.drawView(url);
        }
    },
    drawView: function (url) {
        Cache.set("web:view:id:" + url, function (id) {
            if (id) {
                $("#view-" + id).removeClass("hide");
                return id;
            } else {
                var view = Cache.get("web:view:" + url);
                var idIndex = Cache.get("web:view:id:index");
                $('<section id="view-' + idIndex + '" class="view view-model">').append(view).appendTo('body>.container');
                if (view.charAt(0) === '/' && view.indexOf('//auto load this page\'s javascript') === 0) {
                    var js = url.replace("/public", "/public/javascripts").replace(".html", ".js");
                    var jsText = Cache.get("web:view:auto:load:js:" + js);
                    if (jsText) {
                        eval(jsText);
                    } else {
                        $.get(js, function (text) {
                            Cache.set("web:view:auto:load:js:" + js, text);
                            eval(text);
                        }, "text")
                    }
                }
                return idIndex;
            }
        });
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
    },
    loadJss: function (jss, fn) {
        var back_fn=fn;
        if(jss.length!==undefined) {
            var _j=[];
            for (var i = 1; i < jss.length; i++) {
                _j.push(jss[i]);
            }
            fn=function () {
                Web.loadJss(_j, back_fn);
            }
        }
        $.get(jss[0] || jss, fn);
    },
    loadCss:function (url) {
        var head = document.getElementsByTagName("head")[0];
        var children = head.children;
        for (var i = 0; i < children.length; i++) {
            if (children[i].tagName == "LINK" && children[i].href.indexOf(url) > 0) {
                return;
            }
        }
        var link = document.createElement('link');
        link.type = 'text/css';
        link.rel = 'stylesheet';
        link.href = url;
        head.appendChild(link);
    }
};

var Cache = {
    _value: {},
    get: function (key) {
        return Cache._value[key];
    },
    set: function (key, value) {
        if (typeof value === "function") {
            return Cache._value[key] = value.call(Cache._value, Cache._value[key]);
        } else {
            return Cache._value[key] = value;
        }
    }
};