<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/21
  Time: 13:26
  To change this template use File | Settings | File Templates.
--%>
<%@include file="/WEB-INF/jsp/common/tag.jsp" %>
<%
    //String divCode = request.getParameter("divCode");
    int divCode = (int) (Math.random() * 1000);
    //相关配置
    String containerId = "container_" + divCode;
    String formId = "form_" + divCode;
    String listenOpenEvent = "sqlAddEditEvent";
    String saveUrl = path + "/bi/sql/addedit";
%>


<div id="<%= containerId %>" style="display:none">
    <div class="form-horizontal" id="<%= formId %>">
        <div class="row">
            <div class="control-group span8">
                <label class="control-label">配置名称：</label>
                <div class="controls">
                    <input name="name" type="text" style="height: 29px;width:167px"
                           class="input-normal control-text">
                    <input type="hidden" name="reportId" value="0"/>
                    <input type="hidden" name="sqlId" value="0"/>
                </div>
            </div>

            <div class="control-group span8">
                <label class="control-label">连接名：</label>
                <div class="controls">
                    <input name="dbConn" type="text" style="height: 29px;width:167px"
                           class="input-normal control-text">
                </div>
            </div>
        </div>

        <div class="row">
            <div class="control-group span8">
                <label class="control-label">统计周期：</label>
                <div class="controls">
                    <select name="periodType">
                        <option value="1" checked="checked">分钟</option>
                        <option value="2">小时</option>
                        <option value="3">天</option>
                        <option value="4">月</option>
                        <option value="5">季度</option>
                        <option value="6">年</option>
                    </select>
                </div>
            </div>
            <div class="control-group span8">
                <label class="control-label">状态：</label>
                <div class="controls">
                    <select name="status">
                        <option value="1" checked="checked">可用</option>
                        <option value="2">禁用</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="control-group span8">
                <label class="control-label">开始时间参数：</label>
                <div class="controls">
                    <input name="startTimeParam" type="text" style="height: 29px;width:167px"
                           class="input-normal control-text">
                </div>
            </div>

            <div class="control-group span8">
                <label class="control-label">结束时间参数：</label>
                <div class="controls">
                    <input name="endTimeParam" type="text" style="height: 29px;width:167px"
                           class="input-normal control-text">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="control-group span20" style="height: 220px;">
                <label class="control-label">SQL模板：</label>
                <div class="controls control-row6">
                                    <textarea name="sqlTemplate" class="input-large" style="width:500px;height: 200px;"
                                              type="text">
                                    </textarea>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="control-group span16">
                <label class="control-label">备注：</label>
                <div class="controls control-row4">
                    <textarea name="remark" class="input-large" style="width:460px" type="text"></textarea>
                </div>
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
                    title: '添加编辑拷贝',
                    width: 700,
                    contentId: '<%= containerId %>',
                    success: function () {
                        var item = {};

                        item.name = $('#<%= formId %> [name=name]').val();
                        item.dbConn = $('#<%= formId %> [name=dbConn]').val();
                        item.reportId = $('#<%= formId %> [name=reportId]').val();
                        item.sqlId = $('#<%= formId %> [name=sqlId]').val();

                        item.periodType = $('#<%= formId %> [name=periodType]').val();
                        item.status = $('#<%= formId %> [name=status]').val();

                        item.startTimeParam = $('#<%= formId %> [name=startTimeParam]').val();
                        item.endTimeParam = $('#<%= formId %> [name=endTimeParam]').val();

                        item.sqlTemplate = $('#<%= formId %> [name=sqlTemplate]').val();
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

                    if(!item.reportId || item.reportId<=0){
                        BUI.Message.Alert("没有获取到报表Id", "warning");
                        return false;
                    }

                    dialog.set("title","添加新配置");
                    //清空
                    $('#<%= formId %> [name=name]').val('');
                    $('#<%= formId %> [name=dbConn]').val('');
                    $('#<%= formId %> [name=reportId]').val(0);
                    $('#<%= formId %> [name=sqlId]').val(0);

                    $('#<%= formId %> [name=periodType]').val(1);
                    $('#<%= formId %> [name=status]').val(1);

                    $('#<%= formId %> [name=startTimeParam]').val('');
                    $('#<%= formId %> [name=endTimeParam]').val('');

                    $('#<%= formId %> [name=sqlTemplate]').val('');
                    $('#<%= formId %> [name=remark]').val('');

                    //重新赋值
                    $('#<%= formId %> [name=reportId]').val(item.reportId);

                    //编辑
                    if (item.name && item.name != "") {
                        if(item.sqlId>0){
                            dialog.set("title","编辑");
                            $('#<%= formId %> [name=sqlId]').val(item.sqlId);
                        }else{
                            dialog.set("title","拷贝出新配置");
                        }

                        $('#<%= formId %> [name=name]').val(item.name);
                        $('#<%= formId %> [name=dbConn]').val(item.dbConn);

                        $('#<%= formId %> [name=periodType]').val(item.periodType);
                        $('#<%= formId %> [name=status]').val(item.status);

                        $('#<%= formId %> [name=startTimeParam]').val(item.startTimeParam);
                        $('#<%= formId %> [name=endTimeParam]').val(item.endTimeParam);

                        $('#<%= formId %> [name=sqlTemplate]').val(item.sqlTemplate);
                        $('#<%= formId %> [name=remark]').val(item.remark);
                    }else{
                        dialog.set("title","添加新配置");
                    }

                    dialog.show();
                });

            });

</script>
