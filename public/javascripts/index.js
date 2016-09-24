/**
 * Created by jahv on 2016/9/23.
 */
var $article = $('#article');

var $section = $article.parent();

var articleClick = false, articleId = false, article = {}, articleScrollTop = 0;
var load_more = false;
$(document).on("mousedown", "section>article", function (e) {
    if (!getSelection().toString()) {
        articleClick = [e.clientX, e.clientY];
    } else {
        articleClick = false;
    }
}).on("mouseup", "section>article", function (e) {
    if (articleClick !== false) {
        if (e.clientX === articleClick[0] && e.clientY === articleClick[1]) {
            onClickArticle.call(this);
        }
    }
}).on("click", "header .article-close", function () {
    if (articleId !== false) {
        $('body').removeClass("article");
        article[articleId].hide();
        $("#article-" + articleId).siblings('article').show().end().find(".post-more-link,footer").show();
        $(document).scrollTop(articleScrollTop);
        setTimeout(function () {
            $(document).scrollTop(articleScrollTop);
        }, 200);
    }
});

function scrollLoad() {
    if (load_more === false && $(window).scrollTop() + $(window).height() == $(document).height()) {
        load_more = true;
        var $load = $('<div class="loader-inner triangle-skew-spin"></div>').appendTo($section).loaders();
        var last_id = $section.find(">article:last").data("id");
        $.get("select.article.simple.json", {id: last_id || 0}, function (d) {
            $load.remove();
            if (!d.length)return window.removeEventListener("scroll",scrollLoad);
            $.each(d, function (i, v) {
                Web.generate.article.call($article, v).appendTo($section);
            });
            load_more = false;
        });
    }
}

scrollLoad();

window.addEventListener("scroll", scrollLoad);

function onClickArticle() {
    articleScrollTop = $(document).scrollTop();
    $('body').addClass("article");
    var $this = $(this), id = $this.siblings("article").hide().end().data("id"), load = false, $load;
    $(document).scrollTop(0);
    articleId = id;
    if (article[id]) {
        $this.find(".post-more-link,footer").hide();
        article[id].show();
        return;
    }
    $.get("select.article.remaining.json", {id: id}, function (d) {
        load = true;
        if ($load) {
            console.log($load);
        }
        article[id] = $(d).appendTo($this.find(".post-body"));
    });
    setTimeout(function () {
        $this.find(".post-more-link,footer").hide();
        if (load === false)$load = $('<div class="loader-inner triangle-skew-spin"></div>').appendTo($this).loaders();
    }, 200);
}