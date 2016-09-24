/**
 * Created by jahv on 2016/9/22.
 */
var Web = {
    generate:{
        article:function (data) {
            var article = this.clone().removeClass("hidden");
            article.find(".title").text(data.title);
            article.find("time").text(data.create_datetime.substring(0,data.create_datetime.indexOf('T')))
                .attr("datetime",data.create_datetime);
            article.find(".post-comments-count").text(data.discuss);
            article.find(".leancloud-visitors-count").text(data.click);
            article.find(".post-body").html(data.content);
            if(!data.content_split)article.find(".post-more-link").remove();
            article.data("id", data.id);
            return article.attr("id", "article-" + data.id);
        }
    }
};