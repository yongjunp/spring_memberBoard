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
            .disnone{
                display:none;
            }

        </style>
    </head>

    <body>
        <div class="mainWrap">
            <div class="header">
                <h1>MainPage.jsp</h1>
            </div>

            <%@ include file="/WEB-INF/views/includes/Menu.jsp" %>

            <div class="contents">
                <h2>컨텐츠 영역</h2>
                <p>로그인 아이디: ${sessionScope.loginMemberId}</p>
            </div>
        </div>
    <script src="${pageContext.request.contextPath}/resources/js/main.js">        
    </script>   
    
    <script type="text/javascript">
    loginId = "${sessionScope.loginMemberId}";
    if(loginId == ""){
    	let pEl = document.querySelector(".contents>p");
        pEl.classList.add("disnone");
    	
    }
    </script>
    <script type="text/javascript">
    	let msg = "${msg}";
    	if(msg.length>0){
    		alert(msg);
    	}
    </script> 
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.1.4/toastr.min.js" integrity="sha512-lbwH47l/tPXJYG9AcFNoJaTMhGvYWhVM9YI43CT+uteTRRaiLCui8snIgyAN8XWgNjNhCqlAUdzZptso6OCoFQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/js/NoticeJS.js"></script>
    <script type="text/javascript">
	 let noticeSock = connectNotice('${noticeMsg}');
	</script>
    </body>
	
    </html>