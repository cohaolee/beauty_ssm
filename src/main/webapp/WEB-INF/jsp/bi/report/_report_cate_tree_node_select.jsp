<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/2
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>

<%@include file="/WEB-INF/jsp/common/tag.jsp" %>
<%--参数：${param.pageTitle}--%>

<%

    String divCode = request.getParameter("divCode");
    //配置
    String treeUrl = path + "/bi/reportcate/treenodes";
    String containerDivId = "cateTreeContainer_" + divCode;
    String treeDivId = "cateTree_" + divCode;

    String listenMoveEvent = "reportMoveEvent";
%>


<%--树节点选取--%>
<div style="display:none" id="<%=containerDivId%>">
    <div id="<%=treeDivId%>" class="span6">

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
                        url: '<%=treeUrl%>',
                        map: {
                            'cateId': 'id',
                            'name': 'text',
                        },
                        listeners: {
                            //数据预处理
                            beforeprocessload: function (ev) {
                                if (ev.data && ev.data.length > 0) {
                                    for (var i = 0; i < ev.data.length; i++) {
                                        ev.data[i].leaf = false;
                                        if (ev.data[i].childrenCount == 0) {
                                            ev.data[i].cls = 'x-tree-icon x-tree-elbow-leaf';
                                        }
                                    }
                                }

                            },
                        }

                    });

                    //树形类
                    var tree = new Tree.TreeList({
                        render: '#<%=treeDivId%>',
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
                        contentId: '<%=treeDivId%>',
                        success: function () {
                            var node = tree.getSelected();
                            if (node == null) {
                                BUI.Message.Alert('请选择要移动到的分类', 'error');
                                return false;
                            }
                            dialog.close();
                            callBackFun(node.id);
                        }
                    });

                    var callBackFun;


                    //---------------------------------------
                    //监听主页面事件
                    $("body").bind("<%=listenMoveEvent%>", function (event, successFun) {
                        callBackFun = successFun;
                        dialog.show();
                        treeStore.reloadNode();
                    });

                });


    </script>

</div>