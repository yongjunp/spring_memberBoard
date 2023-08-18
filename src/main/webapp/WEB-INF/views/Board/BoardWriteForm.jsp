
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<link href="${pageContext.request.contextPath}/resources/css/main.css"
	rel="stylesheet">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>

<style>
	div.contents{
		text-align: center;
	}
	h2{
		margin-bottom: 10px;
		margin-top:0px;
	}
	form{
		border-radius: 10px;
		border: 3px solid black;
		text-align: center;
		width: 500px;
		margin-left: auto;
		margin-right: auto;
	}
	form>input{
		padding: 10px;
		border-radius: 10px;
		border: 3px solid black;
		width: 450px;
		margin-top: 10px;
	}
	form>#bCont{
		min-height: 300px;
	}
	form>#submitId{
		margin-bottom: 10px;
	}
</style>
</head>

<body>
	<div class="mainWrap">
		<div class="header">
			<h1>/board/BoardWriteForm.jsp</h1>
		</div>

		<%@ include file="/WEB-INF/views/includes/Menu.jsp"%>

		<div class="contents">
			<h2>글작성 페이지</h2>
			<form action="${pageContext.request.contextPath}/boardWrite" method="post"
			enctype="multipart/form-data"><%-- enctype은 form태그 안에 파일이 있는 경우만 사용한다고 보면된다. --%>
				<input type="text" name="btitle" placeholder="글제목"> 
				<br>
				<input type="text" name="bcontents" placeholder="글내용" id="bCont">
				<br>
				<input type="file" name="bfile" value="파일선택">
				<br> 
				<input type="submit" value="글등록" id="submitId">
			</form>
		</div>
	</div>
	
</body>
<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
<script type="text/javascript">
    	let msg = "${msg}";
    	if(msg.length>0){
    		alert(msg);
    	}
    </script>
    
</html>
	