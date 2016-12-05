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
    String listenOpenEvent = "sqlColumnAddEditEvent";
    String saveUrl = path + "/bi/sqlcolumn/addedit";
%>


<div id="<%= containerId %>" style="display:none">
    <div class="form-horizontal" id="<%= formId %>">
        <div class="row">
            <div class="control-group span8">
                <label class="control-label"><s>*</s>列Code：</label>
                <div class="controls">
                    <input name="columnCode" type="text" style="height: 29px;width:167px"
                           class="input-normal control-text">
                    <input type="hidden" name="reportId" value="0"/>
                    <input type="hidden" name="columnId" value="0"/>
                    <p class="auxiliary-text">和sql模板中[[列code]]一致.</p>
                </div>
            </div>

            <div class="control-group span8">
                <label class="control-label"><s>*</s>列名称：</label>
                <div class="controls">
                    <input name="columnName" type="text" style="height: 29px;width:167px"
                           class="input-normal control-text">
                </div>
            </div>
        </div>

        <div class="row">
            <div class="control-group span8">
                <label class="control-label">列类型：</label>
                <div class="controls">
                    <select name="columnType">
                        <option value="1" checked="checked">数据</option>
                        <option value="2">X轴</option>
                        <option value="3">图例</option>
                    </select>
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

                        item.columnCode = $('#<%= formId %> [name=columnCode]').val();
                        item.columnName = $('#<%= formId %> [name=columnName]').val();
                        item.reportId = $('#<%= formId %> [name=reportId]').val();
                        item.columnId = $('#<%= formId %> [name=columnId]').val();

                        item.columnType = $('#<%= formId %> [name=columnType]').val();

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

                    dialog.set("title","添加SQL列");
                    //清空
                    $('#<%= formId %> [name=columnCode]').val('');
                    $('#<%= formId %> [name=columnName]').val('');
                    $('#<%= formId %> [name=reportId]').val(0);
                    $('#<%= formId %> [name=columnId]').val(0);

                    $('#<%= formId %> [name=columnType]').val(1);
                    $('#<%= formId %> [name=remark]').val('');

                    //重新赋值
                    $('#<%= formId %> [name=reportId]').val(item.reportId);

                    //编辑
                    if (item.columnCode && item.columnCode != "") {
                        dialog.set("title","编辑");

                        $('#<%= formId %> [name=columnCode]').val(item.columnCode);
                        $('#<%= formId %> [name=columnName]').val(item.columnName);

                        $('#<%= formId %> [name=columnType]').val(item.columnType);
                        $('#<%= formId %> [name=remark]').val(item.remark);
                    }else{
                        dialog.set("title","添加新配置");
                    }

                    dialog.show();
                });

            });

</script>
