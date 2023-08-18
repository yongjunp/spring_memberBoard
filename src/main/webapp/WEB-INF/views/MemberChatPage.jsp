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
<script
	src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<style>
.disnone {
	display: none;
}
#Area{
	display: flex;
}
#chatArea {
	border: 2px solid black;
	padding: 10px;
	width: 500px;
	height: 500px;
	background-color: #6884B3;
	border-radius: 10px;
	box-sizing: border-box;
	overflow: overlay;
}

#chatArea::overlay {
	
}

.receiveMsg {
	margin-bottom: 5px;
}

.sendMsg {
	margin-bottom: 5px;
	text-align: right;
}

.commMsg {
	margin-bottom: 5px;
	text-align: center;
}

.sendMsgBox {
	background-color: #F7E600;
	border-radius: 7px;
	max-width: 220px;
	padding: 6px;
}

.receiveMsgBox {
	background-color: white;
	border-radius: 7px;
	padding: 6px;
	margin-top: 0px;
	max-width: 220px;
}

div>span {
	margin: 5px;
	display: inline-block;
}

span.commMsgBox {
	background-color: #9FABCA;
	border-radius: 7px;
	padding: 6px;
	margin: 0;
	min-width: 300px;
}

#inputArea {
	border: 2px solid black;
	padding-left: 10px;
	width: 500px;
	background-color: white;
	border-radius: 10px;
	box-sizing: border-box;
}

#inputArea>input {
	width: 390px;
	padding: 10px;
}

#inputArea>button {
	padding: 5px;
}
#clientList{
	border: 2px solid black;
	padding: 10px;
	width: 250px;
	height: 500px;
	border-radius: 10px;
	box-sizing: border-box;
	overflow: overlay;
}
.client{
	border: 2px solid black;
	border-radius: 10px;
	padding: 10px;
}
</style>
</head>

<body>
	<div class="mainWrap">
		<div class="header">
			<h1>MemberChatPage.jsp</h1>
		</div>

		<%@ include file="/WEB-INF/views/includes/Menu.jsp"%>

		<div class="contents">
			<%--
                <h1>1. pom.xml > spring-websocket, jackson databind 추가</h1>
                <h1>2. com.spring_memberBoard.sockUtil 패키지에 ChatHandler 클래스 생성</h1>
                <h1>3. servlet-conext.xml websocket 설정 추가</h1>
                <h1>4. ChatPage.jsp에 sockjs 기능 추가</h1>
                <h1>5. ChatPage.jsp에 채팅 기능 구현</h1>
             --%>
             <div id="Area">
			<div>
				<div id="chatArea"></div>
				<div id="inputArea">
					<input type="text" id="sendMsg">
					<button onclick="sendMsg()">전송</button>
				</div>
			</div>
				<div id="clientList">
					<div class="client">안녕하세요</div>
				</div>
             </div>


		</div>
	</div>
</body>
<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
<script	src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script type="text/javascript">
	let msgAreaDiv = document.querySelector("#chatArea");
	let inputMsg = document.querySelector("#sendMsg");
	inputMsg.addEventListener("keyup", function(e) {
		if (e.keyCode == 13) {
			sendMsg();
		}
	})
</script>
<script type="text/javascript">
	function sendMsg() {
		sock.send(inputMsg.value);
		let inputDiv = document.createElement("div");
		inputDiv.innerText = "${sessionScope.loginMemberId} : "
				+ inputMsg.value;
		msgAreaDiv.appendChild(inputDiv);
		inputMsg.value = "";
	}
</script>

<script type="text/javascript">
	let chatAreaDiv = document.querySelector("#chatArea");

	function sendMsg() {
		let msgInput = document.querySelector("#sendMsg");
		sock.send(msgInput.value);
		let sendMsgDiv = document.createElement("div");
		sendMsgDiv.classList.add("sendMsg");

		let sendMsgBox = document.createElement("span");
		sendMsgBox.classList.add("sendMsgBox");
		sendMsgBox.innerText = msgInput.value;
		sendMsgDiv.appendChild(sendMsgBox);

		chatAreaDiv.appendChild(sendMsgDiv);

		msgInput.value = "";
		chatAreaDiv.scrollTop = chatAreaDiv.scrollHeight;
	}
</script>

<script type="text/javascript">
	var sock = new SockJS('chatSocket');
	sock.onopen = function() {
		console.log('open');
		//sock.send('test');
	};

	sock.onmessage = function(e) {
		console.log('message', e.data);
		let msgObj = JSON.parse(e.data);
		if (msgObj.msgtype == "m") {
			printMessage(msgObj);
		} else if (msgObj.msgtype == "c") {
			printConnect(msgObj);
			addClient(msgObj);
		} else if (msgObj.msgtype == "d") {
			printConnect(msgObj);
			removeClient(msgObj);
		}

	};

	sock.onclose = function() {
		console.log('close');
	};
</script>
<script type="text/javascript">
    /*
    			<div id="clientList">
					<div class="client">안녕하세요</div>
				</div>
    */
    let clientListDiv = document.getElementById("clientList");
	function addClient(msgObj){
		let clientDiv = document.createElement("div");
		clientDiv.classList.add("client");
		clientDiv.setAttribute("id", msgObj.msgid);
		clientDiv.innerText = msgObj.msgid;
		
		clientListDiv.appendChild(clientDiv);
	}
	function removeClient(msgObj){
		let clientDiv = document.getElementById(msgObj.msgid);
		clientListDiv.removeChild(clientDiv);
	}
</script>
<script type="text/javascript">
	function printMessage(msgObj) {
		let receiveMsgDiv = document.createElement("div");
		receiveMsgDiv.classList.add("receiveMsg");

		let receiveMsgBox = document.createElement("span");
		receiveMsgBox.classList.add("receiveMsgBox");
		receiveMsgBox.innerText = msgObj.msg;

		let brTag = document.createElement("br");

		let nicknameBox = document.createElement("span");
		nicknameBox.classList.add("nickname");
		nicknameBox.innerText = msgObj.msgid;

		receiveMsgDiv.appendChild(nicknameBox);
		receiveMsgDiv.appendChild(brTag);
		receiveMsgDiv.appendChild(receiveMsgBox);
		chatAreaDiv.appendChild(receiveMsgDiv);

		chatAreaDiv.scrollTop = chatAreaDiv.scrollHeight;
	}
	function printConnect(msgObj) {
		let commMsgDiv = document.createElement("div");
		commMsgDiv.classList.add("commMsg");

		let commMsgBox = document.createElement("span");
		commMsgBox.classList.add("commMsgBox");
		commMsgBox.innerText = msgObj.msgid + msgObj.msg;

		commMsgDiv.appendChild(commMsgBox);
		chatAreaDiv.appendChild(commMsgDiv);
		chatAreaDiv.scrollTop = chatAreaDiv.scrollHeight;
	}
</script>

</html>