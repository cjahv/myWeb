/**
 * Created by jahv on 2016/9/23.
 */
var $article = $('#article');
var $section = $article.parent();
$.get("/select.article.simple.json", {page: 1}, function (d) {
    var article = null;
    $.each(d, function (i, v) {
        article = $article.clone().removeClass("hidden");
        article.find(".title").text(v.title);
        article.find("time").text(v.create_datetime.substring(0,v.create_datetime.indexOf('T')))
            .attr("datetime",v.create_datetime);
        article.find(".post-comments-count").text(v.discuss);
        article.find(".leancloud-visitors-count").text(v.click);
        article.find(".post-body").html(v.content);
        article.appendTo($section);
    });
    article.children("footer").remove();
});