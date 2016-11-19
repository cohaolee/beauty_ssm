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
<div style="margin-left:10px;">
    <div class="panel panel-head-borded panel-small">
        <div class="panel-header clearfix">
            <h3 id="gridPanelHeader" class="pull-left">报表</h3>
            <div class="pull-right">
                <input id="txtSearchJobName" type="text" class="control-text"
                       style="height:25px;width:200px;" title="输入名称">
                <button class="button button-small" id="btnSearchJobName" title="在全部中Like搜索">
                    <i class="icon-search"></i>
                    作业名
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



                var columns = [
                    { title: '报表名称', dataIndex: 'name', },
                    { title: '报表备注', dataIndex: 'remark', width: 15 },
                    {
                        title: '状态'
                        , dataIndex: 'status'
                        , renderer: Format.enumRenderer({ 1:"启用", 2:"禁用"})
                        , elStyle: { 'text-align': 'center' }
                        , elCls: "center"
                        , width: 15
                    },
                    {
                        title: '操作', dataIndex: '', renderer: function (value) {
                            var btns = '<span class="grid-command btn-config"><i class="icon icon-edit"></i> 配置</span>';//作业自己相关可变更属性：
                            btns += '<span class="grid-command btn-param"><i class="icon icon-th-list"></i> 参数</span>'; //参数配置（列表管理）
                            return btns;
                        }
                    }
                ];

                    //遮罩层
                    var loadMask = new Mask.LoadMask({
                        el: '#wapper',
                        msg: '正在处理中...'
                    });

                    //列表数据缓存
                    var store = new Store({
                        url: '<%=path%>/bi/report/list',
                        autoLoad: true,
                        params: {
                            cateId: -1,
                            pageSize: 10,
                            pageIndex: 0,
                        },
                        pageSize: 10,
                        autoSync: true,
                        listeners: {
                            load: function () {
                                loadMask.hide();
                            },
                            beforeload: function () {
                                //loadMask.hide();
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
                        bbar: { pagingBar: true, }
                    }).render();

                    //弹出层类(参数)
                    //var dialog = new Overlay.Dialog({
                    //    title: '参数信息',
                    //    width: 700,
                    //    contentId: 'paramContainer',
                    //});

                    var successFun = function () {
                        store.load();
                    }

                    //事件注册-----------------------------------
                    grid.on('cellclick', function (ev) {
                        var item = ev.record;
                        var sender = $(ev.domTarget);
                        if (sender.hasClass('btn-config') || sender.hasClass('label')) {
                            $("body").trigger("itemConfigClicked", [item, successFun]);
                            return false;
                        } else if (sender.hasClass('btn-param')) {
                            $("body").trigger("itemConfigParamClicked", [item, successFun]);
                            return false;
                        }
                    });

                    //操作方法--------------------------------
                    function changeStatus(jobIds, jobStatus) {

                        loadMask.show();
                        $.post('@Url.Action("ChangeJobStatus")'
                                , { jobIds: jobIds, jobStatus: jobStatus }
                                , function (data) {
                                    loadMask.hide();
                                    if (data && data.success) {
                                        store.load();
                                    } else {
                                        if (data.error != '') {
                                            BUI.Message.Alert(data.error, 'error');
                                        }
                                    }
                                }, 'json').error(function (jqXHR, textStatus, responseText) {
                            loadMask.hide();
                            BUI.Message.Alert("网络错误，" + jqXHR.status, "error");
                        });
                    }

                    var loopLoad = setInterval(function () {
                        store.load();
                    }, 10000);


                    $('body').on('cateTreeNodeClick', function (e, item) {
                        loadMask.show();
                        $("#txtSearchJobName").val('');
                        store.load({ cateId: item.cateId, start: 0, pageIndex: 0, jobNameLike: '' });
                    })

                    //工具栏相关======================================================================
                    function search() {
                        var jobNameLike = $("#txtSearchJobName").val();
                        $('#gridPanelHeader').html('全部分类');
                        //if (jobNameLike == '') {
                        //    BUI.Message.Alert("请输入作业名", "error");
                        //    return;
                        //}

                        loadMask.show();
                        store.load({ jobNameLike: jobNameLike, start: 0, pageIndex: 0, cateId: -1 });
                    }

                    function allChangeStatus(fromStatus, toStatus) {
                        loadMask.show();
                        $.post('@Url.Action("ChangeAllJobStatus")'
                                , { fromStatus: fromStatus, toStatus: toStatus }
                                , function (data) {
                                    loadMask.hide();
                                    if (data && data.success) {
                                        store.load();
                                    } else {
                                        if (data.error != '') {
                                            BUI.Message.Alert(data.error, 'error');
                                        }
                                    }
                                }, 'json').error(function (jqXHR, textStatus, responseText) {
                            loadMask.hide();
                            BUI.Message.Alert("网络错误，" + jqXHR.status, "error");
                        });
                    }

                    $('#btnSearchJobName').click(function () {
                        search();
                    })

                    $('#txtSearchJobName').keydown(function (e) {
                        if (e.keyCode == 13) {
                            search();
                        }
                    });

                    $('#btnEnableAllPause').click(function () {
                        BUI.Message.Confirm('确认将所有暂停状态的作业启用吗？', function () {
                            allChangeStatus('@((byte)JobStatus.Pause)', '@((byte)JobStatus.Enable)');
                        }, 'question');
                    });

                    $('#btnPauseAllEnable').click(function () {
                        BUI.Message.Confirm('确认将所有启用状态的作业暂停吗？', function () {
                            allChangeStatus('@((byte)JobStatus.Enable)', '@((byte)JobStatus.Pause)');
                        }, 'question');
                    });


                    $('#btnBatchEnable').click(function () {
                        var selections = grid.getSelection();
                        if (!selections || selections.length <= 0) {
                            BUI.Message.Alert("请选择需启动的项", "warning");
                            return;
                        }

                        var jodIds = [];
                        for (var i = 0; i < selections.length; i++) {
                            jodIds.push(selections[i].jobId);
                        }

                        BUI.Message.Confirm('确认批量启动么？', function () {
                            changeStatus(jodIds, '@((byte)JobStatus.Enable)');
                        }, 'question');
                    });

                    $('#btnBatchStop').click(function () {
                        var selections = grid.getSelection();
                        if (!selections || selections.length <= 0) {
                            BUI.Message.Alert("请选择需停止的项", "warning");
                            return;
                        }

                        var jodIds = [];
                        for (var i = 0; i < selections.length; i++) {
                            jodIds.push(selections[i].jobId);
                        }

                        BUI.Message.Confirm('确认批量停止么？', function () {
                            changeStatus(jodIds, '@((byte)JobStatus.Disable)');
                        }, 'question');
                    });
                });

</script>
