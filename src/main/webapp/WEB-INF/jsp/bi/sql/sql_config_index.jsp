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
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>报表-SQL配置</title>
    <style>
        table {
            font: inherit;
        }
    </style>
</head>

<body>

<div class="main-container" id="cpcontainer">
    <div id="wapper">

        <div style="margin-bottom: 10px;">
            <h3>报表SQL配置</h3>
        </div>

        <div id="tab"></div>

        <script type="text/javascript">
            BUI.use('bui/tab', function (Tab) {

                var tab = new Tab.Tab({
                    render: '#tab',
                    elCls: 'button-tabs',
                    autoRender: true,
                    children: [
                        {text: 'SQL', value: 'SqlConfig'},
                        {text: '参数', value: 'ParamConfig'},
                        {text: '列', value: 'ColumnConfig'}
                    ]
                });

                tab.on('selectedchange', function (ev) {
                    var item = ev.item;
                    $('.tab').hide();
                    $('#tab' + item.get('value')).show();
                    $("body").trigger("clickTab" + item.get('value'));
                });
                tab.setSelected(tab.getItemAt(0));
            });

        </script>



        <div id="tabParamConfig" class="tab" style="display: none">
            <jsp:include page="_sql_param_config_list.jsp"></jsp:include>
        </div>

        <div id="tabColumnConfig" class="tab" style="display: none">
            <jsp:include page="_sql_column_config_list.jsp"></jsp:include>
        </div>

        <div id="tabSqlConfig" class="tab" style="display: none">
            <jsp:include page="_sql_config_list.jsp"></jsp:include>
        </div>
    </div>
</div>


<script>
    $(".nav li").removeClass("active");
    $(".nav li.nav-report").addClass("active");
</script>
</body>
</html>

