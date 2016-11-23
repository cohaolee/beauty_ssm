<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/21
  Time: 13:26
  To change this template use File | Settings | File Templates.
--%>
<%@include file="/WEB-INF/jsp/common/tag.jsp" %>
<%
    //相关配置
    String containerId = "reportContainer";
    String formId = "reportForm";
    String listenOpenEvent = "reportAddEditEvent";
    String saveUrl = path + "/bi/report/addedit";
%>


<div id="<%= containerId %>" style="display:none">
    <div class="form-horizontal" id="<%= formId %>">
        <div class="row">
            <div class="control-group span16">
                <label class="control-label">分类名称：</label>
                <div class="controls">
                    <input name="cateName" type="text" style="width:460px; height: 29px;"
                           class="input-large control-text"
                           readonly="readonly">
                    <input name="cateId" type="hidden" value="0"/>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="control-group span16">
                <label class="control-label">报表名称：</label>
                <div class="controls">
                    <input name="name" type="text" style="width:460px; height: 29px;"
                           class="input-large control-text">
                    <input name="reportId" type="hidden" value="0"/>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="control-group span8">
                <label class="control-label">状态：</label>
                <div class="controls">
                    <select name="status">
                        <option value="1">启用</option>
                        <option value="2">禁用</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="control-group span16">
                <label class="control-label">报表备注：</label>
                <div class="controls control-row4">
                    <textarea name="remark" class="input-large" style="width:460px" type="text"></textarea>
                </div>
            </div>
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

                //遮罩层
                var loadMask = new Mask.LoadMask({
                    el: '.bui-dialog',
                    msg: '正在处理中...',
                });

                //弹出层类(参数)
                var dialog = new Overlay.Dialog({
                    title: '报表添加或编辑',
                    width: 700,
                    contentId: '<%= containerId %>',
                    success: function () {
                        var item = {};

                        item.cateName = $('#<%= formId %> [name=cateName]').val();
                        item.cateId = $('#<%= formId %> [name=cateId]').val();
                        item.reportId = $('#<%= formId %> [name=reportId]').val();
                        item.name = $('#<%= formId %> [name=name]').val();

                        item.status = $('#<%= formId %> [name=status]').val();
                        item.remark = $('#<%= formId %> [name=remark]').val();

                        loadMask.show();
                        $.post('<%= saveUrl %>'
                                , item
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
                $("body").bind("<%= listenOpenEvent %>", function (event, item, successFun) {
                    callBackFun = successFun;

                    if (!item.cateId || item.cateId == 0) {
                        BUI.Message.Alert("添加必须选择分类", 'error');
                        return false;
                    }

                    //清空
                    $('#<%= formId %> [name=cateName]').val('');
                    $('#<%= formId %> [name=cateId]').val(0);
                    $('#<%= formId %> [name=reportId]').val(0);
                    $('#<%= formId %> [name=name]').val('');
                    $('#<%= formId %> [name=status]').val(1);
                    $('#<%= formId %> [name=remark]').val('');

                    //重新赋值
                    $('#<%= formId %> [name=cateName]').val(item.cateName);
                    $('#<%= formId %> [name=cateId]').val(item.cateId);

                    //编辑
                    if (item.reportId && item.reportId > 0) {
                        $('#<%= formId %> [name=reportId]').val(item.reportId);
                        $('#<%= formId %> [name=name]').val(item.name);

                        $('#<%= formId %> [name=status]').val(item.status);
                        $('#<%= formId %> [name=remark]').val(item.remark);
                    }

                    dialog.show();
                });

            });

</script>
