/// <reference path="jquery-1.7.1.js" />
/// <reference path="jquery-ui-1.8.20.js" />
/// <reference path="jquery.validate.js" />
/// <reference path="jquery.validate.unobtrusive.js" />
/// <reference path="knockout-2.1.0.debug.js" />
/// <reference path="modernizr-2.5.3.js" />

/// <reference path="jquery-1.7.1.min.js" />
var Utils = {
    getDate: function (value) {
        return new Date(parseInt(value.replace("/Date(", "").replace(")/", ""), 10));
    },
    //格式化时间
    formatDate: function (value) {
        if (value == null) {
            return "--";
        } else {
            var date = new Date(parseInt(value.replace("/Date(", "").replace(")/", ""), 10));
            //月份为0-11，所以+1，月份小于10时补个0
            var month = date.getMonth() + 1 < 10 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
            var currentDate = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
            return date.getFullYear() + "-" + month + "-" + currentDate;
        }
    },
    //转化为图片显示true或false
    formatBoolean: function (value) {
        var icon = value ? 'ok' : 'cancel';
        return '<span class="tree-file icon-' + icon + '"></span>';
    },
    //性别转换
    formatSex: function (value) {
        switch (value) {
            case 1:
                return "男"; 
            case 2:
                return "女";
            case 3:
                return "保密";
            default:
                return "";
        }
    },
    //是否为日期类型
    isDate: function (value) {
        return Object.prototype.toString.call(value) == "object Date";
    },
    //比较日期大小
    compareDate: function (a, b) {
        var a_arr = a.split("-");
        var a_date = new Date(a_arr[0], a_arr[1], a_arr[2]);
        var a_times = a_date.getTime();
        var b_arr = b.split("-");
        var b_date = new Date(b_arr[0], b_arr[1], b_arr[2]);
        var b_times = b_date.getTime();
        return a_times > b_times;
    },
    //判断对象是否为空
    isEmptyObject: function (obj) {
        for (var name in obj) {
            return false;
        }
        return true;
    },
    getEvent: function (event) {
        return event ? event : window.event;
    },
    preventDefault: function (event) {
        var event = Common.getEvent();
        if (event.preventDefault) {
            event.preventDefault();
        } else {
            event.returnValue = false;
        }
    },
    stopPropagation: function () {
        var event = Common.getEvent();
        if (event.stopPropagation) {
            event.stopPropagation();
        } else {
            event.cancelBubble = true;
        }
    },
    getIcon: function (id) {
        $('#' + id + '').focus(function () {
            $('#select-icon-list').css({ 'left': $(this).offset().left, 'top': $(this).offset().top + $(this).outerHeight() }).fadeTo(0, 0.9).fadeIn('fast');
        });
        $('#select-icon-close').on('click', function () {
            $('#select-icon-list').fadeOut('fast');
        });
        $('#select-icon-list>div.icon-list>a').on('click', function () {
            var icon = $(this).attr('id');
            $('#' + id + '').val(icon);
            $('#' + id + '').siblings().find('a').removeClass().addClass('t-icon').addClass(icon);
            $('#select-icon-list').fadeOut('fast');
        });
    }
};
//拼接字符串，效率比较高，所以可以推荐使用这个，也可以使用传统的+拼接
function StringBuffer() {
    this._strings_ = new Array();
}
StringBuffer.prototype.append = function (str) {
    this._strings_.push(str);
};
//可以传递分隔符，也可以不传递
StringBuffer.prototype.toString = function () {
    if (arguments.length == 0) {
        return this._strings_.join("");
    } else {
        return this._strings_.join(arguments[0]);
    }
};
