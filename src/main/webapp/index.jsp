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
  <link href="pages/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom fonts for this template -->
  <link href="pages/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
  <link href="pages/vendor/simple-line-icons/css/simple-line-icons.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">

  <!-- Custom styles for this template -->
  <link href="pages/css/landing-page.min.css" rel="stylesheet">
</head>

<body>
  <!-- Navigation -->
  <nav class="navbar navbar-light bg-light static-top">
    <div class="container">
      <a class="navbar-brand" href="#">开启知识图谱之旅</a>
      <a class="btn btn-primary" href="#">登录</a>
    </div>
  </nav>

  <!-- Masthead -->
  <header class="masthead text-white text-center">
    <div class="overlay"></div>
    <div class="container">
      <div class="row">
        <div class="col-xl-9 mx-auto">
          <h1 class="mb-5">吧啦吧啦知识图谱</h1>
        </div>
        <div class="col-md-10 col-lg-8 col-xl-7 mx-auto">
        <form action="pages/displaykg.jsp" method="post"> 
        <!-- <form>  -->
            <div class="form-row">
              <div class="col-12 col-md-9 mb-2 mb-md-0">
                <input id="input" name="keyword" type="text" class="form-control form-control-lg" placeholder="输入搜索内容...">
              </div>
              <div class="col-12 col-md-3">
                <button id="sub" type="submit" class="btn btn-block btn-lg btn-primary">开始搜索</button>
              </div>
            </div>
          </form>
          
        </div>
      </div>
    </div>
  </header>

  <!-- Bootstrap core JavaScript -->
  <script src="pages/vendor/jquery/jquery.min.js"></script>
  <script src="pages/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>

<script type="text/javascript">
	$(document).ready(function(){
		$("#i").click(function(){ 
			
			alert("ddS");
		    
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
		});
</script>

</html>