<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<script src="echarts.js" type="text/javascript" charset="utf-8"></script>

<title>知识图谱</title>

<!-- Bootstrap core CSS -->
<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom fonts for this template -->
<link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
<link href="vendor/simple-line-icons/css/simple-line-icons.css"
	rel="stylesheet" type="text/css">
<link
	href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic"
	rel="stylesheet" type="text/css">

<!-- Custom styles for this template -->
<link href="css/landing-page.min.css" rel="stylesheet">
</head>

<body>
	<script src="echarts.js"></script>
	<p id="showjson"></p>
	<%
        request.setCharacterEncoding("utf-8");
        String keyword = request.getParameter("keyword");
        %>

	<form>
		<!--   <form> -->
		<div class="form-row">
			<div class="col-12 col-md-9 mb-2 mb-md-0">
				<input id="input" value=<%=keyword %> name="keyword"
					class="form-control form-control-lg" type="text">
			</div>

		</div>
	</form>
	<!-- Bootstrap core JavaScript -->
	<script src="vendor/jquery/jquery.min.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<div id="chart1"
		style="width: 80%;height: 600px;top: 50px;left: 10%;border: 3px solid #FF0000; "></div>
</body>


<script type="text/javascript">
	
	$(document).ready(function(){
	var chart1 = echarts.init(document.getElementById("chart1"));
			//this.chart1.setOption(option);
			$.ajax({
		        url : "../DisplayServlet", //后台查询验证的方法
		        dataTpye : "json",
		        data : {
		        	keyword:$("#input").val(),
		        }, 
		        type : "post",
		        success : function(data) {
		            //var parsedJson = jQuery.parseJSON(data);  /* 解析json字符串 */
		            var obj=JSON.parse(data);
		            //$("#showjson").html(data);
		            var nodes=obj.nodes;
		            var links=obj.links;
		            var linkss=[];
		            for(var i=0;i<links.length;i++){
		            	var link=links[i];
		            	linkss.push(link.lable);
		            }
		            //$("#showjson").html(linkss);
					var graph = {
					    categories:[{name: "Item"},       //关系网类别
					                {name: "Attribute"},
					                {name: "TemoLete"}],
					    nodes:obj.nodes,
					    links:obj.links,
					}
					var option = {
      title: {
        text: '结果展示',//标题
        subtext: '代码',//标题副标题
        top: 'top',//相对在y轴上的位置
        left: 'center'//相对在x轴上的位置
      },
      tooltip : {//提示框，鼠标悬浮交互时的信息提示
        trigger: 'item',//数据触发类型
        formatter: function(params){//触发之后返回的参数，这个函数是关键
          if (params.data.category !=undefined) {//如果触发节点
            return params.data.category+':'+params.data.label;//返回标签
          }else {//如果触发边
            return '关系:'+params.data.label;
          }
        },
      },
      //工具箱，每个图表最多仅有一个工具箱
      toolbox: {
        show : true,
        feature : {//启用功能
          //dataView数据视图，打开数据视图，可设置更多属性,readOnly 默认数据视图为只读(即值为true)，可指定readOnly为false打开编辑功能
          dataView: {show: true, readOnly: true},
          restore : {show: true},//restore，还原，复位原始图表
          saveAsImage : {show: true}//saveAsImage，保存图片
        }
      },
      //全局颜色，图例、节点、边的颜色都是从这里取，按照之前划分的种类依序选取
      color:['rgb(194,53,49)','rgb(178,144,137)','rgb(97,160,168)'],
      //图例，每个图表最多仅有一个图例
      legend: [{
        x: 'left',//图例位置
        //图例的名称，这里返回短名称，即不包含第一个，当然你也可以包含第一个，这样就可以在图例中选择主干人物
        data: graph.categories.map(function (a) {
                return a.name;
            })
      }],
      //sereis的数据: 用于设置图表数据之用
      series : [
        {
          name: '人际关系网络图',//系列名称
          type: 'graph',//图表类型
          layout: 'force',//echarts3的变化，force是力向图，circular是和弦图
          draggable: true,//指示节点是否可以拖动
          data: graph.nodes,//节点数据
          links: graph.links,//边、联系数据
          categories: graph.categories,//节点种类
          focusNodeAdjacency:true,//当鼠标移动到节点上，突出显示节点以及节点的边和邻接节点
          roam: true,//是否开启鼠标缩放和平移漫游。默认不开启。如果只想要开启缩放或者平移，可以设置成 'scale' 或者 'move'。设置成 true 为都开启
          label: {//图形上的文本标签，可用于说明图形的一些数据信息
            normal: {
              show : true,//显示
              position: 'right',//相对于节点标签的位置
              //回调函数，你期望节点标签上显示什么
              formatter: function(params){
              	if(params.data.label.length>6){
              		return 	params.data.label.substring(0,5)+"...";
              	}
                return params.data.label;
              },
            }
          },
          //节点的style
          itemStyle:{
            normal:{
              opacity:0.9,//设置透明度为0.8，为0时不绘制
            },
          },
          // 关系边的公用线条样式
          lineStyle: {
            normal: {
              show : true,
              color: 'target',//决定边的颜色是与起点相同还是与终点相同
              curveness: 0.1//边的曲度，支持从 0 到 1 的值，值越大曲度越大。
            }
          },
          force: {
            edgeLength: [100,200],//线的长度，这个距离也会受 repulsion，支持设置成数组表达边长的范围
            repulsion: 100//节点之间的斥力因子。值越大则斥力越大
          },
		edgeSymbol : ['circle', 'arrow'],//边两端的标记类型，可以是一个数组分别指定两端，也可以是单个统一指定。默认不显示标记，常见的可以设置为箭头，如下：edgeSymbol: ['circle', 'arrow']
		 
		edgeSymbolSize : 10,//边两端的标记大小，可以是一个数组分别指定两端，也可以是单个统一指定。
        }
      ]
    };
					chart1.setOption(option) 
		        },
		        error:function(){  //请求失败的回调方法
		        	alert("请求失败，请重试");
		        }
			
			});
		});
		
</script>

</html>