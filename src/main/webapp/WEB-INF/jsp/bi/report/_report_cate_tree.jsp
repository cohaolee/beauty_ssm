<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/2
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>

<%@include file="/WEB-INF/jsp/common/tag.jsp" %>
<%--参数：${param.pageTitle}--%>

<%--树形左栏--%>
<div class="span8">
    <div class="panel panel-head-borded panel-small">
        <div class="panel-header clearfix">
            <h3 class="pull-left">分类</h3>
            <div class="pull-right">
                <button class="button button-small" id="btnNodeForward" title="排序前进"><i class="icon-chevron-up"></i>
                </button>
                <button class="button button-small" id="btnNodeBack" title="排序后退"><i class="icon-chevron-down"></i>
                </button>
                <button class="button button-small" id="btnNodeAdd" title="添加子分类"><i class="icon-plus-sign"></i>
                </button>
                <button class="button button-small" id="btnNodeEdit" title="编辑当前节点"><i class="icon-edit"></i>
                </button>
                <button class="button button-small" id="btnNodeMove" title="编辑当前节点"><i class="icon-move"></i>
                </button>
                <button class="button button-small" id="btnNodeDelete" title="删除当前结点，有子节点不能删除"><i
                        class="icon-remove"></i>
                </button>
            </div>
        </div>
        <div id="tree">

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
                        msg: '处理中...'
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
                            load: function () {
                                console.log('load');
                                console.log('curSelectedNodeId ' + curSelectedNodeId);

                                if (needSelected && tree && curSelectedNodeId > 0) {
                                    setTimeout(function () {
                                        var node = tree.findNode(curSelectedNodeId);
                                        //移动时，节点有可能移动到未加载的节点上
                                        if(node) {
                                            tree.setSelected(node);
                                            needSelected = false;
                                            console.log('load->selected')
                                        }
                                    }, 300);
                                }
                            },
                        }

                    });

                    var curSelectedNodeId = 0;
                    var needSelected = false;

                    //树形类
                    var tree = new Tree.TreeList({
                        render: '#tree',
                        height: uiControlHeight,
                        store: treeStore,
                        checkType: 'none',
                        showRoot: true,
                        showLine: true,
                        listeners: {
                            itemselected: function (ev) {
                                if (ev.item) {
                                    curSelectedNodeId = ev.item.id;
                                } else {
                                    console.log(ev);
                                }

                                console.log('curSelectedNodeId ' + curSelectedNodeId);
                            },
                        },
                    }).render();


//                    tree.on('itemclick', function (ev) {
//                        var item = ev.item;
//                        $('body').trigger('treeNodeClick', item);
//                    });

                    var refreshNodeFun = function () {
                        var node = tree.getSelected();
                        if (node) {
                            treeStore.loadNode(node, true);
                            needSelected = true;
                            return;
                        }
                    }

                    var refreshParentNodeFun = function () {
                        var node = tree.getSelected();
                        if (node) {
                            treeStore.loadNode(node.parent, true);
                            needSelected = true;
                            console.log('refreshParentNodeFun')
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
                        $('body').trigger('addOrEditClicked', [node, 1, refreshNodeFun]);
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


                    $("#btnNodeForward").click(function () {
                        var node = tree.getSelected();
                        if (!node || node.cateId == -1) {
                            return;
                        }
                        removeSort(node, true);
                    });

                    $("#btnNodeBack").click(function () {
                        var node = tree.getSelected();
                        if (!node || node.cateId == -1) {
                            return;
                        }
                        removeSort(node, false);
                    });

                    //节点上下移动
                    function removeSort(node, forward) {
                        loadMask.show();
                        $.post('<%=path%>/bi/reportcate/removesort'
                                , {cateId: node.id, parentId: node.parent.id, forward: forward}
                                , function (data) {
                                    loadMask.hide();
                                    if (data && data.success) {
                                        refreshParentNodeFun();
                                    } else {
                                        if (data.error != '') {
                                            BUI.Message.Alert(data.error, 'error');
                                        }
                                    }
                                }, 'json')
                                .error(function (jqXHR, textStatus, responseText) {
                                    loadMask.hide();
                                    treeStore.loadNode(node.parent, true);
                                    BUI.Message.Alert("网络错误，" + jqXHR.status, "error");
                                });
                    }

                    //移动子树到指定节点
                    $("#btnNodeMove").click(function () {
                        var node = tree.getSelected();
                        if (!node || node.cateId == -1) {
                            BUI.Message.Alert("请选择节点", "error");
                            return;
                        }
                        if (node.id == 0) {
                            BUI.Message.Alert("不能移动根节点", "error");
                            return;
                        }

                        refreshNode = node;
                        $('body').trigger('moveClicked', [node, refreshParentNodeFun, treeStore]);
                    });


                    $("#btnNodeDelete").click(function () {
                        var node = tree.getSelected();
                        if (!node || node.cateId == -1) {
                            return;
                        }
                        BUI.Message.Confirm("确认删除？", function () {
                            $.post('<%=path%>/bi/reportcate/delete'
                                    , {cateId: node.id}
                                    , function (data) {
                                        loadMask.hide();
                                        if (data && data.success) {
                                            curSelectedNodeId = node.parent.id;//焦点移动到父类
                                            refreshParentNodeFun();
                                        } else {
                                            if (data.error != '') {
                                                BUI.Message.Alert(data.error, 'error');
                                            }
                                        }
                                    }, 'json')
                                    .error(function (jqXHR, textStatus, responseText) {
                                        loadMask.hide();
                                        BUI.Message.Alert("网络错误，" + jqXHR.status, "error");
                                    });
                        });
                    });
                });

    </script>
</div>

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
                      <label class="control-label">描述：</label>
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

                        $('#nodeForm [name=parentId]').val(0);
                        $('#nodeForm [name=parentName]').val('');
                        $('#nodeForm [name=cateId]').val(0);
                        $('#nodeForm [name=name]').val('');

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

<%--树节点选取--%>
<div style="display:none" id="moveTreeContainer">
    <div id="moveTree" class="span6">

    </div>

    <script type="text/javascript">
        BUI.use(['bui/data', 'bui/overlay', 'bui/mask', 'bui/tree']
                , function (Data, Overlay, Mask, Tree) {

                    //UI元素定义---------------------------------
                    var Grid = Grid;
                    var Store = Data.Store;

                    //遮罩层
                    var loadMask = new Mask.LoadMask({
                        el: '.bui-dialog',
                        msg: '处理中...',
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
                        },
                        listeners: {
                            //数据预处理
                            beforeprocessload: function (ev) {
                                var deleteItemIndex = 0;
                                if (ev.data && ev.data.length > 0) {
                                    for (var i = 0; i < ev.data.length; i++) {
                                        ev.data[i].leaf = false;
                                        if (ev.data[i].cateId == moveNodeId) {
                                            deleteItemIndex = i;
                                        }
                                    }
                                }

                                //移除当前要移动的节点
                                if (deleteItemIndex > 0) {
                                    ev.data.splice(deleteItemIndex, 1);
                                }

                            },
                        }

                    });

                    //树形类
                    var tree = new Tree.TreeList({
                        render: '#moveTreeContainer',
                        height: 300,
                        store: treeStore,
                        checkType: 'none',
                        showRoot: true,
                        showLine: true,
                        listeners: {},
                    }).render();


                    //弹出层类(参数)
                    var dialog = new Overlay.Dialog({
                        title: '移动到',
                        width: 300,
                        contentId: 'moveTreeContainer',
                        success: function () {
                            var param = {};
                            param.cateId = moveNodeId;
                            if (tree.getSelected() == null) {
                                BUI.Message.Alert('请选择要移动到的节点', 'error');
                                return false;
                            }
                            param.parentId = tree.getSelected().id;

                            loadMask.show();
                            $.post('<%=path%>/bi/reportcate/move'
                                    , param
                                    , function (data) {
                                        loadMask.hide();
                                        if (data && data.success) {
                                            callBackFun();
                                            setTimeout(function () {
                                                var node = _mainTreeStore.findNode(param.parentId);
                                                _mainTreeStore.reloadNode(node);
                                                //_mainTreeStore.load({id: param.parentId});
                                            }, 300);

                                            dialog.close();
                                        } else if (data.error && data.error != '') {
                                            BUI.Message.Alert(data.error, 'error');
                                            return false;
                                        }
                                    }, 'json')
                                    .error(function (jqXHR, textStatus, responseText) {
                                        loadMask.hide();
                                        BUI.Message.Alert("网络错误，" + jqXHR.status, "error");
                                        return false;
                                    });

                        }
                    });

                    var callBackFun;
                    var moveNodeId = 0;
                    var _mainTreeStore;

                    //---------------------------------------
                    //监听主页面事件
                    $("body").bind("moveClicked", function (event, item, successFun, mainTreeStore) {
                        callBackFun = successFun;
                        moveNodeId = item.id;
                        _mainTreeStore = mainTreeStore;
                        console.log("moveNodeId：" + moveNodeId);
                        dialog.show();


                        var rootNode = treeStore.findNode(0);
                        treeStore.reloadNode(rootNode);
                        //treeStore.load({id: 0}); 该方式不稳定
                    });

                });


    </script>

</div>



