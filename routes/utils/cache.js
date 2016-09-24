/**
 * Created by jahv on 2016/9/24.
 */
var cache = {};

module.exports = {
    get:function (key) {
        return cache[key];
    },
    set:function (key, val) {
        return cache[key] = val;
    }
};