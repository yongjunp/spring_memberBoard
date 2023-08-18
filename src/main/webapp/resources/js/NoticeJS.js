/**
 * NoticeJS.js
 */
 
	 function connectNotice(noticeMsg){
			var noticeSock = new SockJS('noticeSocket');
			noticeSock.onopen = function() {
			     console.log('open');
			     if(noticeMsg.length > 0){
			      noticeSock.send(noticeMsg);
			     }
			 };

			 noticeSock.onmessage = function(e) {
			     console.log('message', e.data);
			     //toastr 호출 알람 출력
			     noticeAlert(e.data)
			 };

			 noticeSock.onclose = function() {
			     console.log('close');
			 };
			 return noticeSock;
	 	}
	 	
	 	function noticeAlert(msgObj_str){
	 		let msgObj = JSON.parse(msgObj_str);
	 		let mtype = msgObj.msgtype;
	 		switch(mtype){
	 		case "reply":
	 			toastr.options.onclick = function(){
	 			location.href='/controller/boardView?bno='+msgObj.msgcomm;	 			
	 			}
	 			toastr.success(msgObj.msgcomm+"번 게시물에 댓글이 추가 되었습니다.");
	 			break;
	 		case "board":
	 			toastr.options.onclick = function(){
	 			location.href='/controller/boardList';	 			
	 			}
	 			toastr.info(msgObj.msgcomm);
	 			break;	
	 		}
	 	}