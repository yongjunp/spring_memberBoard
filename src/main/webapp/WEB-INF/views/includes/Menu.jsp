<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<div class="nav">
	<ul>
		<li><a href="${pageContext.request.contextPath}/boardList">게시판</a></li>
		<li><a href="${pageContext.request.contextPath}/tagoBus">타고버스</a></li>
		<!-- 
		<li><a href="${pageContext.request.contextPath}/busapi">버스노선</a></li>
		 -->
		<c:choose>
			<c:when test="${sessionScope.loginMemberId == null}">
				<li><a href="${pageContext.request.contextPath}/MemberJoinForm">회원가입</a></li>
				<li><a href="${pageContext.request.contextPath}/MemberLoginForm">로그인</a></li>
			</c:when>
			<c:otherwise>
				<li><a href="${pageContext.request.contextPath}/MemInfo">내정보</a></li>
				<li><a href="${pageContext.request.contextPath}/boardWriteForm">글쓰기</a></li>
				<li><a href="${pageContext.request.contextPath}/MemberLogout">로그아웃</a></li>
			</c:otherwise>
		</c:choose>
	</ul>
</div>