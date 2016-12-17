<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/2
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>

<%@include file="/WEB-INF/jsp/common/tag.jsp" %>
<%
    String listUrl = path + "/bi/sql/list";
    String deleteUrl = path + "/bi/sql/delete";
    String copyUrl = path + "/bi/sql/copy";

    String triggerAddEditEvent = "sqlAddEditEvent";

    int divCode = (int) (Math.random() * 1000);
    String gridDivId = "grid_" + divCode;
%>

<div class="panel panel-head-borded panel-small">
            <div class="panel-header clearfix">
                <h3 class="pull-left">${report.name}
                 <input id="reportId" type="hidden" value="${report.reportId}">
                </h3>
                <div class="pull-right">
                    <button class="button" id="btnListRefresh" title="刷新列表">
                        <i class="icon-refresh"></i>
                    </button>
                    <button class="button" id="btnAddSqlConfig" title="添加报表">
                        <i class="icon-plus-sign"></i>
                    </button>
                </div>
            </div>
            <div id="<%=gridDivId%>">

            </div>

            <script type="text/javascript">
                BUI.use(['bui/grid', 'bui/data', 'bui/overlay', 'bui/mask']
                        , function (Grid, Data, Overlay, Mask) {

                            //UI元素定义---------------------------------
                            var Grid = Grid;
                            var Store = Data.Store;
                            var Format = Grid.Format;

                            var columns = [
                                {
                                    title: '周期类型'
                                    , dataIndex: 'periodType'
                                    , renderer: Format.enumRenderer({1: "分钟", 2: "小时", 3: "天", 4:"月", 5:"季度", 6:"年"})
                                    , elStyle: {'text-align': 'center'}
                                    , elCls: "center"
                                    , width: 70
                                },
                                {title: '报表名称', dataIndex: 'name',},
                                {
                                    title: '状态'
                                    , dataIndex: 'status'
                                    , renderer: Format.enumRenderer({1: '<span class="label label-success">启用</span>', 2: "禁用"})
                                    , elStyle: {'text-align': 'center'}
                                    , elCls: "center"
                                    , width: 50
                                },
                                {title: '报表备注', dataIndex: 'remark',},
                                {title: '开始时间参数', dataIndex: 'startTimeParam',},
                                {title: '结束时间参数', dataIndex: 'endTimeParam',},
                                {title: '连接名', dataIndex: 'dbConn',},
                                {title: '创建时间', dataIndex: 'createTime',},
                                {title: '更新时间', dataIndex: 'updateTime',},
                                {
                                    title: '操作', dataIndex: '', renderer: function (value) {
                                    var btns = '<span class="grid-command btn-edit"><i class="icon icon-edit"></i> 编辑</span>';
                                    btns += '<span class="grid-command btn-copy" title="拷贝一个出一个新的配置，默认禁用"><i class="icon icon-share"></i> 拷贝</span>';
                                    btns += '<span class="grid-command btn-delete"><i class="icon icon-remove-sign"></i> 删除</span>';
                                    return btns;
                                }, width: 100
                                }
                            ];

                            //遮罩层
                            var loadMask = new Mask.LoadMask({
                                el: '#<%=gridDivId%>',
                                msg: '正在处理中...'
                            });

                            //列表数据缓存
                            var store = new Store({
                                url: '<%=listUrl%>',
                                autoLoad: true,
                                params: {
                                    reportId: ${report.reportId},
                                },
                                autoSync: true,

                                root: 'data',               //存放数据的字段名(rows)
                                totalProperty: 'total',     //存放记录总数的字段名(results)

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
                                render: '#<%=gridDivId%>',
                                //height: uiControlHeight,
                                columns: columns,
                                store: store,
                                idField: 'Id',
                                forceFit: true,
                                plugins: [Grid.Plugins.CheckSelection, Grid.Plugins.ColumnResize, Grid.Plugins.RowNumber, Grid.Plugins.AutoFit],
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
                                }if (sender.hasClass('btn-copy')) {
                                    //item.oldSqlId = item.sqlId;
                                    //item.sqlId = 0;
                                    //$("body").trigger("<%= triggerAddEditEvent %>", [item, successFun]);

                                    var param = {sqlId: item.sqlId};
                                    $.post('<%=copyUrl%>'
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
                                    return false;
                                } else if (sender.hasClass('btn-delete')) {
                                    BUI.Message.Confirm('确认删除？（将删除所有的依赖数据记录）', function () {
                                        $.post('<%=deleteUrl%>'
                                                , {sqlId: item.sqlId}
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

                            $("#btnAddSqlConfig").click(function () {
                                var item = {};
                                item.reportId =  $("#reportId").val();
                                $("body").trigger("<%= triggerAddEditEvent %>", [item, successFun]);
                            })

                            $("body").bind('clickTabSqlConfig', function () {
                                loadMask.show();
                                store.load();
                            })
                        });

            </script>

        </div>



<jsp:include page="_sql_add_edit.jsp"></jsp:include>


<script>
    $(".nav li").removeClass("active");
    $(".nav li.nav-report").addClass("active");
</script>
</body>
</html>

