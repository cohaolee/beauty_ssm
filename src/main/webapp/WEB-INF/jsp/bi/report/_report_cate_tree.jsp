<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/2
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setCharacterEncoding("utf-8");
    String path = request.getContextPath();
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="<%=path%>/resource/ui/bui/css/bs3/dpl-min.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/ui/bui/css/bs3/bui-min.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/ui/bui/cs/extension.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/css/admin/adminview.css" rel="stylesheet"/>

    <script src="<%=path%>/resource/js/jquery-1.10.2.min.js"></script>
    <script src="<%=path%>/resource/ui/bui/seed-min.js" data-debug="true"></script>
    <script src="<%=path%>/resource/js/util/bui-util.js"></script>

    <title>模板</title>

</head>

<body>
<div class="main-container" id="cpcontainer">

    <div class="span8">
        <div class="panel panel-head-borded panel-small">
            <div class="panel-header clearfix">
                <h3 class="pull-left">报表分类</h3>
                <div class="pull-right">
                    <button class="button button-small" id="btnNodeUp" title="向上"><i class="icon-chevron-up"></i>
                    </button>
                    <button class="button button-small" id="btnNodeDown" title="向下"><i class="icon-chevron-down"></i>
                    </button>
                    <button class="button button-small" id="btnNodeAdd" title="添加"><i class="icon-plus-sign"></i>
                    </button>
                    <button class="button button-small" id="btnNodeEdit" title="编辑"><i class="icon-edit"></i></button>
                    <button class="button button-small" id="btnNodeDelete" title="删除"><i class="icon-remove"></i>
                    </button>
                </div>
            </div>
            <div id="tree">

            </div>
        </div>
    </div>


    <%--@*分类树*@--%>
    <script>
        var winHeight = $(window).height() - 140;
        var uiControlHeight = winHeight < 500 ? 500 : winHeight;

        BUI.use(['bui/data', 'bui/overlay', 'bui/mask', 'bui/tree']
                , function (Data, Overlay, Mask, Tree) {
                    //遮罩层
                    var loadMask = new Mask.LoadMask({
                        el: '#grid',
                        msg: '正在处理中...'
                    });

                    //树形数据缓存类
                    var treeStore = new Data.TreeStore({
                        root: {
                            id: 0,
//                            cateId: -1,
                            text: '全部',
                            cls: 'icon-home',
                        },
                        pidField: 'parentId',
                        autoLoad: true,
                        autoSync: true,
                        url: '<%=path%>/reportcate/treenodes',
                        map: {
                            'cateId': 'id',
                            'name': 'text',
//                            'sort' : 'leaf' ,
//                          'nodes' : 'children'
                        },
                        listeners: {
                            //数据预处理
                            beforeprocessload: function (ev) {
                                if (ev.data && ev.data.length > 0) {
                                    for (var i = 0; i < ev.data.length; i++) {
                                        ev.data[i].leaf = false;
                                    }
                                }
                            },
                        }

                    });

                    //树形类
                    var tree = new Tree.TreeList({
                        render: '#tree',
                        height: uiControlHeight,
                        store: treeStore,
                        checkType: 'none',
                        showRoot: true,
                        showLine: true,
                    }).render();


                    tree.on('itemclick', function (ev) {
                        var item = ev.item;
                        $('body').trigger('treeNodeClick', item);
                    });

                    $("#btnNodeUp").click(function () {
                        var node = tree.getSelected();
                        if (!node || node.cateId == -1) {
                            return;
                        }
                        upDownCate(node, true);
                    });

                    $("#btnNodeDown").click(function () {
                        var node = tree.getSelected();
                        if (!node || node.cateId == -1) {
                            return;
                        }
                        upDownCate(node, false);
                    });

                    //节点上下移动
                    function upDownCate(node, up) {
                        loadMask.show();
                        $.post('@Url.Action("TreeNodeUpOrDown", "JobCate")'
                                , {cateId: node.cateId, parentId: node.parent.cateId, up: up}
                                , function (data) {
                                    loadMask.hide();
                                    treeStore.loadNode(node.parent, true);
                                    if (data && data.success) {
                                        store.load();
                                    } else {
                                        if (data.error != '') {
                                            BUI.Message.Alert(data.error, 'error');
                                        }
                                    }
                                }, 'json').error(function (jqXHR, textStatus, responseText) {
                            loadMask.hide();
                            treeStore.loadNode(node.parent, true);
                            BUI.Message.Alert("网络错误，" + jqXHR.status, "error");
                        });
                    }


                    $("#btnCateDelete").click(function () {
                        var node = tree.getSelected();
                        if (!node || node.cateId == -1) {
                            return;
                        }
                        $.post('@Url.Action("DeleteNode", "JobCate")'
                                , {cateId: node.cateId}
                                , function (data) {
                                    loadMask.hide();
                                    treeStore.loadNode(node.parent, true);
                                    if (data && data.success) {
                                        store.load();
                                    } else {
                                        if (data.error != '') {
                                            BUI.Message.Alert(data.error, 'error');
                                        }
                                    }
                                }, 'json').error(function (jqXHR, textStatus, responseText) {
                            loadMask.hide();
                            treeStore.loadNode(node.parent, true);
                            BUI.Message.Alert("网络错误，" + jqXHR.status, "error");
                        });
                    });
                });
    </script>


</div>

</body>
</html>

