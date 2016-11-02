function getAction(url) {
    if (!url || url == "") {
        return "";
    }
    url = url.toLowerCase();
    if (url.indexOf('?') > 0) {
        url = url.substr(0, url.indexOf('?'));
    }
    var action = url.substring(url.lastIndexOf('/') + 1, url.length);
}