<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>知识图谱</title>

  <!-- Bootstrap core CSS -->
  <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom fonts for this template -->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
  <link href="vendor/simple-line-icons/css/simple-line-icons.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">

  <!-- Custom styles for this template -->
  <link href="css/landing-page.min.css" rel="stylesheet">
</head>

<body>
  

 <p id="showjson"></p>
        <%
        request.setCharacterEncoding("utf-8");
        String keyword = request.getParameter("keyword");
        %>
        
         <form> 
        <!--   <form> -->
            <div class="form-row">
              <div class="col-12 col-md-9 mb-2 mb-md-0">
                <input id="input" value=<%=keyword %> name="keyword" class="form-control form-control-lg" type="hidden">
              </div>
           
            </div>
          </form>
          
     


  <!-- Bootstrap core JavaScript -->
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>


<script type="text/javascript">
	$(document).ready(function(){
		    
			$.ajax({
		        url : "../DisplayServlet", //后台查询验证的方法
		        dataTpye : "json",
		        data : {
		        	keyword:$("#input").val(),
		        }, 
		        type : "post",
		        success : function(data) {
		            var parsedJson = jQuery.parseJSON(data);  /* 解析json字符串 */

		            $("#showjson").html(data);
		        },
		        error:function(){  //请求失败的回调方法
		        	alert("请求失败，请重试");
		        }
		 
			
			});
		});
</script>

</html>