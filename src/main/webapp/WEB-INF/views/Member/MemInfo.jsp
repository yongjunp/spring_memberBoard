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
.disnone {
	display: none;
}

.contents {
	text-align: center;
}

form {
	display: flex;
	justify-content: center;
	width: 500px;
	margin-left: auto;
	margin-right: auto;
	border: 3px solid black;
	border-radius: 10px;
	padding: 20px;
}

div.myInfo {
	text-align: center;
	border: 3px solid black;
	border-radius: 10px;
	width: 600px;
	margin-left: auto;
	margin-right: auto;
}

div.myInfo>ul {
	/* border: 3px solid black;
                border-radius: 10px; */
	margin-left: auto;
	margin-right: auto;
	padding: 0px;
	list-style-type: none;
}

div.myInfo>ul>li {
	margin: 10px;
	display: flex;
}

div.myInfo>ul>li>div {
	padding: 5px;
}

div#boardno {
	width: 10%;
	border-top: 1px solid black;
}

div#boardtitle {
	width: 50%;
	border-top: 1px solid black;
}

div#boardwriter {
	width: 20%;
	border-top: 1px solid black;
}

div#boardhits {
	width: 10%;
	border-top: 1px solid black;
}
div#boardstate {
	width: 10%;
	border-top: 1px solid black;
}

button{
	margin-bottom: 10px;
}
</style>
</head>

<body>
	<div class="mainWrap">
		<div class="header">
			<h1>/Member/MemInfo.jsp</h1>
		</div>

		<%@ include file="/WEB-INF/views/includes/Menu.jsp"%>

		<div class="contents">
			<c:if test="${mem == null}">
				<form action="${pageContext.request.contextPath}/checkInfo"
					method="post">
					<p>비밀번호 : </p>
					<input type="text" name="inputPw" placeholder="비밀번호"> <input
						type="submit" value="확인">
				</form>
			</c:if>

			<c:if test="${mem != null }">
				<div class="myInfo">
					<p>아이디 : ${mem.mid}</p>
					<p>비밀번호 : ${mem.mpw}</p>
					<p>이름 : ${mem.mname}</p>
					<p>생년월일 : ${mem.mbirth}</p>
					<p>이메일 : ${mem.memail}</p>
					<button
					onclick="location.href='${pageContext.request.contextPath}/modifyInfo'">내정보
					수정</button>
				</div>
				<hr>
				<div class="myInfo">
					<ul>
						<li id="listHeader">
							<div id="boardno">글번호</div>
							<div id="boardtitle">글제목</div>
							<div id="boardwriter">작성자</div>
							<div id="boardhits">조회수</div>
							<div id="boardstate">글상태</div>
						</li>
						<c:forEach var="board" items="${bList}">
							<li>
								<div id="boardno">${board.bno }</div>
								<div id="boardtitle">
									<a
										href="${pageContext.request.contextPath}/boardView?bno=${board.bno}">${board.btitle}</a>
								</div>
								<div id="boardwriter">${board.bwriter }</div>
								<div id="boardhits">${board.bhits }</div>
								<div id="boardstate">
								<c:choose>
									<c:when test="${board.bstate == '0'}">비공개</c:when>
									<c:otherwise>공개</c:otherwise>
								</c:choose>
								</div>
							</li>
						</c:forEach>
					</ul>
				</div>
				<hr>
				<div class="myInfo">
						<span>작성한 댓글 갯수 : ${recount}</span>
				</div>
			</c:if>

		</div>
	</div>
	<script src="${pageContext.request.contextPath}/resources/js/main.js">
		
	</script>


	<script type="text/javascript">
		let msg = "${msg}";
		if (msg.length > 0) {
			alert(msg);
		}
	</script>
</body>

</html>