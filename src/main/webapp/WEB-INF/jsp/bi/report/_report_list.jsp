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

    //配置
    String listenRefreshEvent = "treeNodeClick";
    String triggerAddEditEvent = "reportAddEditEvent";
    String triggerMoveEvent = "reportMoveEvent";
    String listUrl = path + "/bi/report/list";
    String deleteUrl = path + "/bi/report/delete";
    String moveUrl = path + "/bi/report/move";
%>

<%--树形左栏--%>
<div style="margin-left:10px;">
    <div class="panel panel-head-borded panel-small">
        <div class="panel-header clearfix">
            <h3 id="gridPanelHeader" class="pull-left">报表</h3>
            <div class="pull-right">
                <input id="txtSearchName" type="text" class="control-text"
                       style="height:25px;width:200px;" title="输入名称">
                <button class="button" id="btnSearchName" title="在全部中Like搜索">
                    <i class="icon-search"></i>
                </button>
                <button class="button" id="btnListRefresh" title="刷新列表">
                    <i class="icon-refresh"></i>
                </button>
                <button class="button" id="btnAddReport" title="添加报表">
                    <i class="icon-plus-sign"></i>
                </button>
                <button class="button" id="btnReportMove" title="移动报表到指定分类">
                    <i class="icon-move"></i>
                </button>
            </div>
        </div>
        <div id="grid">

        </div>
    </div>
</div>

<script type="text/javascript">
    BUI.use(['bui/grid', 'bui/data', 'bui/overlay', 'bui/mask']
            , function (Grid, Data, Overlay, Mask) {

                //UI元素定义---------------------------------
                var Grid = Grid;
                var Store = Data.Store;
                var Format = Grid.Format;
                var curCateId = 0;
                var curCateName = "";


                var columns = [
                    {title: '报表分类', dataIndex: 'cateName',},
                    {title: '报表名称', dataIndex: 'name',},
                    {title: '报表备注', dataIndex: 'remark',},
                    {title: '创建时间', dataIndex: 'createTime',},
                    {title: '更新时间', dataIndex: 'updateTime',},
                    {
                        title: '状态'
                        , dataIndex: 'status'
                        , renderer: Format.enumRenderer({1: "启用", 2: "禁用"})
                        , elStyle: {'text-align': 'center'}
                        , elCls: "center"
                        , width: 50
                    },
                    {
                        title: '操作', dataIndex: '', renderer: function (value) {
                        var btns = '<span class="grid-command btn-edit"><i class="icon icon-edit"></i> 编辑</span>';
                        btns += '<span class="grid-command btn-sql"><i class="icon icon-th-list"></i> SQL</span>';
                        btns += '<span class="grid-command btn-delete"><i class="icon icon-remove-sign"></i> 删除</span>';
                        return btns;
                    }, width: 100
                    }
                ];

                //遮罩层
                var loadMask = new Mask.LoadMask({
                    el: '#grid',
                    msg: '正在处理中...'
                });

                //列表数据缓存
                var store = new Store({
                    url: '<%=listUrl%>',
                    autoLoad: true,
                    params: {
                        cateId: -1,
                        pageSize: 20,
                        pageIndex: 0,
                    },
                    pageSize: 20,
                    autoSync: true,

                    root: 'data',               //存放数据的字段名(rows)
                    totalProperty: 'total',    //存放记录总数的字段名(results)

                    listeners: {
                        load: function () {
                            loadMask.hide();
                        },
                        beforeload: function () {
                            //loadMask.hide();
                        },
                        //发生在，beforeload和load中间，数据已经获取完成，但是还未触发load事件，用于获取返回的原始数据
                        beforeprocessload: function (ev) {
                            if (ev.data && !ev.data.success) {
                                BUI.Message.Alert("获取数据错误，" + ev.data.error, "error");
                                return false;
                            }
                        }
                    }

                })

                //表格类
                var grid = new Grid.Grid({
                    render: '#grid',
                    height: uiControlHeight,
                    columns: columns,
                    store: store,
                    idField: 'Id',
                    forceFit: true,
                    plugins: [Grid.Plugins.CheckSelection, Grid.Plugins.ColumnResize, Grid.Plugins.RowNumber, Grid.Plugins.AutoFit],
                    bbar: {pagingBar: true,}
                }).render();

                var successFun = function () {
                    loadMask.show();
                    store.load();
                }

                //事件注册======================================================================

                grid.on('cellclick', function (ev) {
                    var item = ev.record;
                    var sender = $(ev.domTarget);
                    if (sender.hasClass('btn-edit')) {
                        $("body").trigger("<%= triggerAddEditEvent %>", [item, successFun]);
                        return false;
                    } else if (sender.hasClass('btn-delete')) {
                        BUI.Message.Confirm('确认删除？（将删除所有的依赖数据记录）', function () {
                            $.post('<%=deleteUrl%>'
                                    , {reportId: item.reportId}
                                    , function (data) {
                                        loadMask.hide();
                                        if (data && data.success) {
                                            store.load();
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
                        }, 'question');

                        return false;
                    }
                });


                $("#btnListRefresh").click(function () {
                    loadMask.show();
                    store.load();
                })

                $("#btnAddReport").click(function () {
                    var item = {}
                    item.cateId = curCateId;
                    item.cateName = curCateName;
                    $("body").trigger("<%= triggerAddEditEvent %>", [item, successFun]);
                })

                $("#btnListRefresh").click(function () {
                    loadMask.show();
                    store.load();
                })

                $("#btnSearchName").click(function () {
                    var nameLike = $("#txtSearchName").val();
                    if (nameLike == '') {
                        BUI.Message.Alert("请输入报表名称", "error");
                        return;
                    }
                    $('#gridPanelHeader').html('全部分类');
                    loadMask.show();
                    store.load({nameLike: nameLike, start: 0, pageIndex: 0, cateId: -1});
                })


                //移动
                $("#btnReportMove").click(function () {
                    var selections = grid.getSelection();
                    if (!selections || selections.length <= 0) {
                        BUI.Message.Alert("请选择需移动的项", "warning");
                        return;
                    }

                    $("body").trigger("<%= triggerMoveEvent %>"
                            , [
                                function (moveToCateId) {
                                    var selections = grid.getSelection();
                                    if (!selections || selections.length <= 0) {
                                        BUI.Message.Alert("没有获取到已选择的报表", "warning");
                                        return;
                                    }

                                    if (moveToCateId == 0) {
                                        BUI.Message.Alert("没有获取到分类数据", "warning");
                                        return;
                                    }

                                    loadMask.show();

                                    var ids = [];
                                    for (var i = 0; i < selections.length; i++) {
                                        ids.push(selections[i].reportId);
                                    }

                                    var param = {};
                                    param.cateId = moveToCateId;
                                    param.ids = ids;

                                    $.post('<%=moveUrl%>'
                                            , param
                                            , function (data) {
                                                loadMask.hide();
                                                if (data && data.success) {
                                                    store.load();
                                                } else if (data.error && data.error != '') {
                                                    BUI.Message.Alert(data.error, 'error');
                                                    return false;
                                                }
                                            }, 'json')
                                            .error(function (jqXHR, textStatus, responseText) {
                                                loadMask.hide();
                                                BUI.Message.Alert("网络错误，" + jqXHR.status + "，" + textStatus, "error");
                                                return false;
                                            });

                                }
                            ]);
                })


                //刷新
                $("body").bind("<%= listenRefreshEvent %>", function (event, item) {
                    loadMask.show();
                    curCateId = item.cateId;
                    curCateName = item.name;
                    $('#gridPanelHeader').html('当前：' + curCateName);
                    $("#txtSearchName").val('');
                    store.load({cateId: curCateId, pageIndex: 0});
                });

            });

</script>

<jsp:include page="_report_cate_tree_node_select.jsp">
    <jsp:param name="divCode" value="<%=(int)(Math.random()*1000)%>"/>
</jsp:include>
