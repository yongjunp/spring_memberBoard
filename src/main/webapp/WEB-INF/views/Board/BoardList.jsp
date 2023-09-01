<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>메인페이지</title>
        <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
        <%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
        <script src="https://kit.fontawesome.com/65020fc203.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.1.4/toastr.css" integrity="sha512-oe8OpYjBaDWPt2VmSFR+qYOdnTjeV9QPLJUeqZyprDEQvQLJ9C5PCFclxwNuvb/GQgQngdCXzKSFltuHD3eCxA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <style>
            .disnone{
                display:none;
            }
            div.contents>ul{
                width: 700px;
                /* border: 3px solid black;
                border-radius: 10px; */
                margin-left: auto;
                margin-right: auto;
                padding: 0px;
                list-style-type: none;
            }
            div.contents>ul>li{
                margin: 10px;
                display: flex;
            }
            div.contents>ul>li>div{
            	padding: 5px;
            }
            div#boardno{
                width: 10%;
                border-top:1px solid black;
            }
            div#boardtitle{
                width: 60%;
                border-top:1px solid black;
            }
            div#boardtitle>p{
                margin: 0;
            }
            div#boardwriter{
                width: 20%;
                border-top:1px solid black;
            }
            div#boardhits{
                width: 10%;
                border-top:1px solid black;
            }
        </style>
    </head>

    <body>
        <div class="mainWrap">
            <div class="header">
                <h1>/board/BoardList.jsp</h1>
            </div>

            <%@ include file="/WEB-INF/views/includes/Menu.jsp" %>

            <div class="contents">
				<ul>
                    <li id="listHeader"> 
                        <div id="boardno">글번호</div> 
                        <div id="boardtitle">글제목</div> 
                        <div id="boardwriter">작성자</div> 
                        <div id="boardhits">조회수</div>
                    </li>

                        <c:forEach var="board" items="${bList}">
                            <li>
                                <div id="boardno">${board.bno }</div> 
                                <div id="boardtitle">
                                    <c:choose>
                                        <c:when test="${board.bstate == '1' }">
                                            <a href="${pageContext.request.contextPath}/boardView?bno=${board.bno}">${board.btitle}</a>                    	
                                            <c:if test = "${board.bfilename != null }"> <span><i class="fa-solid fa-image"></i></span></c:if>
                                           <c:if test="${board.recount != 0 }"><span><i class="fa-regular fa-comment"></i>${board.recount }</span></c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <p>삭제된 게시글입니다.</p>
                        	</c:otherwise>
                        </c:choose>
                    </div> 
                    <div id="boardwriter">${board.bwriter }</div> 
                        <div id="boardhits">${board.bhits }</div>
                    </li>                    
                </c:forEach>
            </ul>
            <hr>
            <%--
            <ul>
                    <li id="listHeader"> 
                        <div id="boardno">글번호</div> 
                        <div id="boardtitle">글제목</div> 
                        <div id="boardwriter">작성자</div> 
                        <div id="boardhits">조회수</div>
                    </li>

                        <c:forEach var="bomap" items="${bListMap}">
                            <li>
                                <div id="boardno">${bomap.BNO }</div> 
                                <div id="boardtitle">
                                    <c:choose>
                                        <c:when test="${bomap.BSTATE == '1' }">
                                            <a href="${pageContext.request.contextPath}/boardView?bno=${bomap.BNO}">${bomap.BTITLE}</a>                    	
                                            <c:if test = "${bomap.BFILENAME != null }"> <span><i class="fa-solid fa-image"></i></span></c:if>
                                           <c:if test="${bomap.RECOUNT != 0 }"><span><i class="fa-regular fa-comment"></i>${bomap.RECOUNT }</span></c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <p>삭제된 게시글입니다.</p>
                        	</c:otherwise>
                        </c:choose>
                    </div> 
                    <div id="boardwriter">${bomap.BWRITER}</div> 
                        <div id="boardhits">${bomap.BHITS }</div>
                    </li>                    
                </c:forEach>
            </ul>
             --%>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/resources/js/main.js">        
    </script>   
    <script type="text/javascript">
    	console.log("${bList.get(0)}")
    </script>
    <script type="text/javascript">
    	let msg = "${msg}";
    	if(msg.length>0){
    		alert(msg);
    	}
    </script> 
    </body>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.1.4/toastr.min.js" integrity="sha512-lbwH47l/tPXJYG9AcFNoJaTMhGvYWhVM9YI43CT+uteTRRaiLCui8snIgyAN8XWgNjNhCqlAUdzZptso6OCoFQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/js/NoticeJS.js"></script>
    <script type="text/javascript">
    $(document).ready(function(){
    	if("${noticeMsg}".length > 0){
		let noticeSock = connectNotice('{"noticeType":"board", "noticeMsg":"10"}');
    		
    	}
    	
    })
	</script>

    </html>