/**
 * Created by jahv on 2016/9/30.
 */
Web.loadJss([
    "/public/plugins/simditor-2.3.6/scripts/module.min.js",
    "/public/plugins/simditor-2.3.6/scripts/hotkeys.min.js",
    "/public/plugins/simditor-2.3.6/scripts/uploader.min.js",
    "/public/plugins/simditor-2.3.6/scripts/simditor.min.js"
], function () {
    Web.loadCss("/public/plugins/simditor-2.3.6/styles/simditor.css");
    var editor = new Simditor({textarea: $('#editor')});
});