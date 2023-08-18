<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>메인페이지</title>
		<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.1.4/toastr.css" integrity="sha512-oe8OpYjBaDWPt2VmSFR+qYOdnTjeV9QPLJUeqZyprDEQvQLJ9C5PCFclxwNuvb/GQgQngdCXzKSFltuHD3eCxA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
		<style>
			div.contents {
				text-align: center;
			}

			h2 {
				margin-bottom: 10px;
				margin-top: 0px;
			}

			form {
				border-radius: 10px;
				border: 3px solid black;
				text-align: center;
				width: 500px;
				margin-left: auto;
				margin-right: auto;
			}

			form>input {
				padding: 10px;
				border-radius: 10px;
				border: 3px solid black;
				width: 450px;
				margin-top: 10px;
			}

			form>#bCont {
				min-height: 300px;
				padding: 10px;
				border-radius: 10px;
				border: 3px solid black;
				width: 450px;
				margin-top: 10px;
			}

			form>#submitId {
				margin-bottom: 10px;
			}

			input.middleInput {
				width: 25%;
			}

			button {
				margin: 5px;
			}

			div#imgBox {
				display: inline-block;

			}

			div#imgBox>img {
				margin-top: 10px;
				width: 450px;
			}
			div.reply{
				display: flex;
			}
			div.reply>p{
				padding:0;
				margin:3px;
			}
			textarea.recomm{
				margin-top: 5px;
				border-radius: 7px;
				width: 96%;
				min-height: 70px;
				font-family: auto;
				resize: none;
				padding: 8px;
			}
			textarea#commentValue{
				margin-top: 5px;
				border-radius: 7px;
				width: 70%;
				min-height: 70px;
				font-family: auto;
				resize: none;
				padding: 8px;
			}
			button#inputComment{
				min-height: 70px;
				width: 25%;
				border-radius: 7px;
				margin-top: 5px;
				padding: 8px;
			}

		</style>
	</head>

	<body>
		<div class="mainWrap">
			<div class="header">
				<h1>/board/BoardView.jsp</h1>
			</div>

			<%@ include file="/WEB-INF/views/includes/Menu.jsp" %>

				<div class="contents">
					<h2>글 내용 페이지</h2>
					<form action="${pageContext.request.contextPath}/boardWrite" method="post"
						enctype="multipart/form-data"><%-- enctype은 form태그 안에 파일이 있는 경우만 사용한다고 보면된다. --%>
							<input type="text" name="btitle" placeholder="글제목" value="${board.btitle}" readonly>
							<input type="text" class="middleInput" value="${board.bwriter}">
							<input type="text" class="middleInput" value="${board.bhits}">
							<input type="text" class="middleInput" value="${board.bdate}">
							<c:if test="${board.bfilename != null}">
								<div id="imgBox">
									<img src="${pageContext.request.contextPath}/resources/boardUpload/${board.bfilename}">
								</div>
							</c:if>
							<br>
							<textarea id="bCont" readonly>${board.bcontents}</textarea>
							<br>
							<c:if test="${board.bwriter == sessionScope.loginMemberId}">
								<c:choose>
									<c:when test="${board.bstate == 1}">
										<button
											onclick="location.href='${pageContext.request.contextPath}/removeBoard?bno=${board.bno}'"
											type="button">글삭제</button>
									</c:when>
									<c:otherwise>
										<button
											onclick="location.href='${pageContext.request.contextPath}/rollbackBoard?bno=${board.bno}'"
											type="button">글되돌리기</button>
									</c:otherwise>
								</c:choose>
							</c:if>
							<button type="button"
								onclick="location.href='${pageContext.request.contextPath}/boardList'">글목록</button>
					</form>
					<hr>
					<c:if test="${sessionScope.loginMemberId != null}">
					<h3>댓글작성양식</h3>
					<input type="hidden" name="rebno" value="${board.bno}" readonly>
					<input type="hidden" name="bwriter" value = "${board.bwriter }">
					<textarea id="commentValue" name="recomment" placeholder="댓글 내용 작성"></textarea>
					<button id="inputComment" onclick="inputComment()">댓글 등록</button>
					<hr>
					</c:if>
					<h3>댓글 출력</h3>
					<div id="reListArea"></div>
					
					</div>
		</div>
		<hr>

	</body>
	<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.1.4/toastr.min.js" integrity="sha512-lbwH47l/tPXJYG9AcFNoJaTMhGvYWhVM9YI43CT+uteTRRaiLCui8snIgyAN8XWgNjNhCqlAUdzZptso6OCoFQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/js/NoticeJS.js"></script>
    <script type="text/javascript">
	 let noticeSock = connectNotice('${noticeMsg}');
	</script>
	
	<script type="text/javascript">
		//댓글 받아오기
		function getReplyList(rebno){
			console.log("getReplyList() 호출")
			console.log("댓글 조회할 글 번호: " + rebno)
			$.ajax({
				type: "get",
				url : "replyList",
				data: {"rebno" : rebno},
				dataType: "json",
				success: function(reList){
					printReplyList(reList); //댓글 출력 기능 호출
					
				}
			})
		}
	</script>


<script type="text/javascript">
	//댓글 출력기능
	let loginId = "${sessionScope.loginMemberId}";
	function printReplyList(reList){
			let reListAreaEl = document.querySelector("#reListArea");
			reListAreaEl.innerHTML = "";
			//for(let reInfo of reList){}
			for(let i =0; i < reList.length; i++){
				let replyEl = document.createElement("div");
				replyEl.classList.add("reply");

			let reWriter = document.createElement("p");
			reWriter.innerText = reList[i].remid;
			replyEl.appendChild(reWriter);

			let reDate = document.createElement("p");
			reDate.innerText = reList[i].redate;
			replyEl.appendChild(reDate);
			
			if(loginId == reList[i].remid){	
				let removeButton = document.createElement("button")
				removeButton.innerText = "댓글 삭제";
				removeButton.setAttribute("onclick", "delReply('"+reList[i].renum+"')");
				replyEl.appendChild(removeButton);
			}
			
			let recommEl = document.createElement("textarea");
			recommEl.setAttribute("disabled", "disabled");
			recommEl.classList.add("recomm")
			if(reList[i].restate == '0'){
				recommEl.value = "삭제된 댓글입니다.";
			} else {				
			recommEl.value = reList[i].recomment;
			}
			
			let hrEl = document.createElement("hr");

			reListAreaEl.appendChild(replyEl);
			reListAreaEl.appendChild(recommEl);
			reListAreaEl.appendChild(hrEl);
			}

		}
		</script>
		<script type="text/javascript">
			function delReply(renum){
			console.log("댓글 삭제버튼 누름");
			console.log(renum);
			let confirmVal = confirm('댓글을 삭제 하시겠습니까?');
			 $.ajax({
			 	type:"get",
			 	url:"/controller/removeReply",
			 	data:{"renum": renum},
			 	success:function(rs){
			 		console.log(rs);
					location.href="${pageContext.request.contextPath}/boardView?bno=${board.bno}"
			 	}
			 })
		}
	</script>
	<script type="text/javascript">
		let bno = '${board.bno}';
		$(document).ready(function(){
			getReplyList(bno);
		})

	</script>

	<script type="text/javascript">
		let commentEl = document.getElementById("commentValue");
		function inputComment(){
			$.ajax({
				type:"get",
				url:"/controller/inputComment",
				data:{"inputComment":commentEl.value,
					"inputBno" : "${board.bno}",
					"inputLoginId" : "${sessionScope.loginMemberId}"},
				success:function(rs){
					getReplyList("${board.bno}");
					let noticeObj = {"noticeType":"reply", "noticeMsg":"${board.bno}", "receiveId":"${board.bwriter}" };
					noticeSock.send(JSON.stringify(noticeObj));
				}

			})
		}

	</script>

	<script type="text/javascript">
		let msg = "${msg}";
		if (msg.length > 0) {
			alert(msg);
		}
	</script>

	</html>