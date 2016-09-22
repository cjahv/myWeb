/**
 * Created by jahv on 2016/9/22.
 */
var $appConfig = require("../conf/app");
var _ = require("underscore");
var md5 = require("md5");

var shaArr = null;
var shaNullCount = 0;
module.exports = {
    getPassword: function (password) {
        if (shaArr === null) {
            shaArr = [];
            var sha = $appConfig.user.sha, p = $appConfig.user.password.split(''), len = sha.length, count = 0, i = 0, index = 0;
            while (true) {
                if (count >= len || i >= p.length) {
                    shaArr.push(sha.substr(count));
                    break;
                }
                shaArr.push(sha.substr(count, p[i]));
                shaArr.push(null);
                count += parseInt(p[i]) || 0;
                i++;
                shaNullCount++;
            }
        }
        var shaClone = _.extend([], shaArr);
        var p_len = password.length;
        var step = parseInt(p_len / shaNullCount) || 1;
        var p_index = 0;
        for (var j = 0; j < shaNullCount; j++) {
            shaClone[j + 1] = password.substr(p_index, step);
            p_index += step;
        }
        shaClone[shaNullCount] = password.substr(p_index);
        return md5(shaClone.join('-'));
    }
};