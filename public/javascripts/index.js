/**
 * Created by jahv on 2016/9/23.
 */
var $article = $('#article');

var $section = $article.parent();

var articleClick = false, article = {}, articleScrollTop = 0,startArticleId=0;
var load_more = false;

var title = $("head title").text();
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
    var articleId = parseInt(location.pathname.substring(16, location.pathname.lastIndexOf('.')));
    Web.changeUrl("/public/index.html#article-"+articleId);
    $('body').removeClass("article");
    var $this=$("#article-" + articleId).siblings('article').show().end().find(".post-more-link,footer").show().end();
    if(!article[articleId]){
        $this.remove();
        startArticleId = articleId - 2;
        scrollLoad();
    }else{
        article[articleId].hide();
        $(document).scrollTop(articleScrollTop);
        setTimeout(function () {
            $(document).scrollTop(articleScrollTop);
        }, 200);
    }
    load_more = false;
});

function scrollLoad() {
    if($('body').is(".article"))return;
    if (load_more === false && $(window).scrollTop() + $(window).height() == $(document).height()) {
        load_more = true;
        var $load = $('<div class="loader-inner triangle-skew-spin"></div>').appendTo($section).loaders();
        var last_id = $section.find(">article:last").data("id");
        $.get("select.article.simple.json", {id: last_id || startArticleId}, function (d) {
            $load.remove();
            if (!d.length)return window.removeEventListener("scroll",scrollLoad);
            $.each(d, function (i, v) {
                Web.generate.article.call($article, v).appendTo($section);
            });
            load_more = false;
            if(location.hash) {
                $(document).scrollTop($(location.hash).offset().top-$(window).height()*.2);
                Web.changeUrl(location.pathname);
            }
        });
    }
}

scrollLoad();

window.addEventListener("scroll", scrollLoad);

function onClickArticle() {
    articleScrollTop = $(document).scrollTop();
    load_more = true;
    $('body').addClass("article");
    var $this = $(this), id = $this.siblings("article").hide().end().data("id"), load = false, $load;
    var _title = $this.find(".title").text();
    Web.changeUrl("/public/article/"+id+".html",false);
    document.title = `${_title}${title}`;
    $(document).scrollTop(0);
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