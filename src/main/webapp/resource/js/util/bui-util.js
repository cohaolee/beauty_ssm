//将Object中的bool属性转换为字符类型，只支持一层
function fieldToStr(item) {
    for (var i in item) {
        switch (typeof item[i]) {
            case 'boolean':
                item[i] = item[i].toString();
                break;
            default:
        }
    }
    return item;
}

//对象克隆
//Object.prototype.clone = function () {
//    if (this.constructor == Number
//         || this.constructor == String
//         || this.constructor == Boolean)
//        return this.valueOf();

//    var newobj;
//    newobj = new this.constructor();

//    for (var key in this) {
//        if (newobj[key] != this[key])
//            newobj[key] = this[key].clone();
//    }
//    newobj.toString = this.toString;
//    newobj.valueOf = this.valueOf;
//    return newobj;
//}