<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/2
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>

<%@include file="../../common/tag.jsp" %>

<%--
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setCharacterEncoding("utf-8");
    String path = request.getContextPath();
%>
--%>

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
                    <button class="button button-small" id="btnNodeAdd" title="添加子分类"><i class="icon-plus-sign"></i>
                    </button>
                    <button class="button button-small" id="btnNodeEdit" title="编辑当前节点"><i class="icon-edit"></i>
                    </button>
                    <button class="button button-small" id="btnNodeDelete" title="删除当前结点，有子节点不能删除"><i
                            class="icon-remove"></i>
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
                            text: '全部',
                            cls: 'icon-home',
                        },
                        pidField: 'parentId',
                        autoLoad: true,
                        autoSync: true,
                        url: '<%=path%>/bi/reportcate/treenodes',
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


//                    tree.on('itemclick', function (ev) {
//                        var item = ev.item;
//                        $('body').trigger('treeNodeClick', item);
//                    });

                    var refreshNodeFun = function(){
                        var node = tree.getSelected();
                        if (node) {
                            treeStore.loadNode(node, true);
                            return;
                        }
                    }

                    var refreshParentNodeFun = function(){
                        var node = tree.getSelected();
                        if (node) {
                            treeStore.loadNode(node.parent, true);
                            return;
                        }

                    }


                    //触发事件====================
                    $("#btnNodeAdd").click(function () {
                        var node = tree.getSelected();
                        if (!node || node.cateId == -1) {
                            BUI.Message.Alert("请选择节点", "error");
                            return;
                        }

                        refreshNode = node;
                        $('body').trigger('addOrEditClicked', [node, 1, refreshParentNodeFun]);
                    });

                    $("#btnNodeEdit").click(function () {
                        var node = tree.getSelected();
                        if (!node || node.cateId == -1) {
                            BUI.Message.Alert("请选择节点", "error");
                            return;
                        }
                        if (node.id == 0) {
                            BUI.Message.Alert("不能编辑根节点", "error");
                            return;
                        }

                        refreshNode = node;
                        $('body').trigger('addOrEditClicked', [node, 2, refreshParentNodeFun]);
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


    <%--添加，修改节点--%>
    <div style="display:none">
        <div id="nodeContainer" style="display:none">
            <div class="form-horizontal" id="nodeForm">

                <div class="row">
                    <div class="control-group span8">
                        <label class="control-label">上级分类：</label>
                        <div class="controls">
                            <input name="parentName" type="text" class="input-normal control-text"
                                   style="height: 29px;width:167px" readonly="readonly">
                            <input type="hidden" name="parentId" value="0"/>
                            <%--commandType 1添加 2修改--%>
                            <input type="hidden" name="commandType" value="0"/>
                        </div>
                    </div>

                </div>
                <div class="row">
                    <div class="control-group span8">
                        <label class="control-label">分类名称：</label>
                        <div class="controls">
                            <input name="name" type="text" style="height: 29px;width:167px"
                                   class="input-normal control-text">
                            <input type="hidden" name="cateId" value="0"/>
                        </div>
                    </div>
                </div>


                <%--<div class="row">
                    <div class="control-group span8">
                        <label class="control-label">状态：</label>
                        <div class="controls">
                            <select name="status">
                                <option value="1" checked="checked">可用</option>
                                <option value="2">禁用</option>
                            </select>
                        </div>
                    </div>
                </div>--%>

                <%--  <div class="row">
                      <div class="control-group span16">
                          <label class="control-label">作业描述：</label>
                          <div class="controls control-row4">
                              <textarea name="jobDesc" class="input-large" style="width:460px" type="text"></textarea>
                          </div>
                      </div>
                  </div>--%>
            </div>
        </div>


        <script type="text/javascript">
            BUI.use(['bui/data', 'bui/overlay', 'bui/mask']
                    , function (Data, Overlay, Mask) {

                        //UI元素定义---------------------------------
                        var Grid = Grid;
                        var Store = Data.Store;

                        //遮罩层
                        var loadMask = new Mask.LoadMask({
                            el: '.bui-dialog',
                            msg: '处理中...',
                        });

                        //弹出层类(参数)
                        var dialog = new Overlay.Dialog({
                            title: '分类管理',
                            width: 400,
                            contentId: 'nodeContainer',
                            success: function () {
                                var param = {}
                                param.parentId = $('#nodeForm [name=parentId]').val();
                                param.cateId = $('#nodeForm [name=cateId]').val();
                                param.name = $('#nodeForm [name=name]').val();

                                param.commandType = $('#nodeForm [name=commandType]').val();

                                loadMask.show();
                                $.post('<%=path%>/bi/reportcate/addoredit'
                                        , param
                                        , function (data) {
                                            loadMask.hide();
                                            if (data && data.success) {
                                                callBackFun();
                                                dialog.close();
                                            } else if (data.error && data.error != '') {
                                                BUI.Message.Alert(data.error, 'error');
                                            }
                                        }, 'json')
                                        .error(function (jqXHR, textStatus, responseText) {
                                            loadMask.hide();
                                            BUI.Message.Alert("网络错误，" + jqXHR.status, "error");
                                        });

                            }
                        });

                        var callBackFun;

                        //---------------------------------------
                        //监听主页面事件
                        $("body").bind("addOrEditClicked", function (event, item, commandType, successFun) {
                            callBackFun = successFun;

                            console.log(callBackFun);

                            $('#nodeForm [name=commandType]').val(commandType);
                            //添加子节点
                            if (commandType == 1) {
                                $('#nodeForm [name=parentId]').val(item.id);
                                $('#nodeForm [name=parentName]').val(item.text);
                            }
                            //编辑
                            if (commandType == 2) {
                                var parentItem = item.parent;
                                $('#nodeForm [name=parentId]').val(parentItem.id);
                                $('#nodeForm [name=parentName]').val(parentItem.text);
                                $('#nodeForm [name=cateId]').val(item.id);
                                $('#nodeForm [name=name]').val(item.text);
                            }
                            dialog.show();
                        });

                    });

        </script>

    </div>

</body>
</html>

