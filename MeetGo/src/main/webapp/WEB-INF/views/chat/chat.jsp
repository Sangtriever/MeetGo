<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<title>채팅</title>
	
	<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
	
	<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
	<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css" />
	<link href="<%=request.getContextPath()%>/resources/css/chat/chat.css?after" rel="stylesheet" type="text/css">
	
	
	<style>
        .preview-img {
            position: absolute;
            background-color: #e1e1e1;
			width: 650px;
			height: 400px;
			top:400px;
			align-items: center;
			box-sizing: border-box;
			text-align: center;
			display: flex;
			justify-content: center;
		}
		.preview-img-close {
			position: absolute;
			bottom: 360px;
			right: 20px;
			cursor: pointer;
		}
		.preview-img img {
			max-width: 500px;
			max-height: 350px;
			object-fit: cover;
		}
        .overlay-right-box{
			position: relative;
		}
		.hide-right-box{
			position: absolute;
			width: 100%;
			height: 100%;
            background: rgba(0, 0, 0, 0.8);
			text-align: center;
			align-items: center;
			padding-top: 30%;
		}
	</style>
</head>
<body>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="estimateForm.jsp"/>
<div class="chat-content">
	<div class="left-box">
		<div class="left-box-input-search" >
			<div class="view-type" id="view-type" data-toggle="collapse" data-target="#type-collapse">
				<div style="width: 80%; text-align: center">
					<c:choose>
						<c:when test="${requestScope.type == 'noread'}">
							안 읽음
						</c:when>
						<c:when test="${requestScope.type == 'chating'}">
							협의중
						</c:when>
						<c:when test="${requestScope.type == 'complete'}">
							완료
						</c:when>
						<c:otherwise>
							전체
						</c:otherwise>
					</c:choose>
				</div>
				<img src="<%=request.getContextPath()%>/resources/images/chat/wing-icon.png" style="width: 50px; height: 50px">
			</div>
			<div class="chat-search-input display-none" id="search-type">
				<b>이름 또는 내용으로 검색</b>
				<input type="text" placeholder="검색어를 입력하세요.">
			</div>
			<div class="chat-search">
				<img src="<%=request.getContextPath()%>/resources/images/chat/search-icon.png">
				<img class="display-none" src="<%=request.getContextPath()%>/resources/images/chat/close-icon.png">
			</div>
		</div>
		<script>
            var chatSearch = document.querySelector('.chat-search');
            var viewType = document.getElementById('view-type');
            var searchType = document.getElementById('search-type');
            var searchIcon = chatSearch.querySelector('img[src$="search-icon.png"]');
            var closeIcon = chatSearch.querySelector('img[src$="close-icon.png"]');

            chatSearch.addEventListener('click', function() {
                searchIcon.classList.toggle('display-none');
                closeIcon.classList.toggle('display-none');
                viewType.classList.toggle('display-none');
                searchType.classList.toggle('display-none');
            });
		</script>
		<div id="type-collapse" class="collapse">
			<a>전체</a>
			<a>안 읽음</a>
			<a>협의 중</a>
			<a>완료</a>
		</div>
		<script>
            var links = document.querySelectorAll('#type-collapse a');
            links.forEach(function(link) {
                link.addEventListener('mouseover', function() {
                    this.style.backgroundColor = 'lightgray';
                });
                link.addEventListener('mouseout', function() {
                    this.style.backgroundColor = '';
                });
            });
		</script>
		
		<div class="left-box-chatList">
			<c:forEach var="b" items="${requestScope.chatroomList}">
				<div class="chat-card">
					<input type="hidden" class="chatroomNo" value="${b.chatroom.chatroomNo}">
					<div class="chat-card-img">
						<img src="${b.userProfile}">
					</div>
					<div class="chat-card-info">
						<p>${b.userName}</p>
						<p>마지막 채팅 불러오기</p>
					</div>
				</div>
			</c:forEach>
		</div>
		
		<script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
		<script>
			let chatroomNo;
            let userNo;
            let gosuNo;
            let estNo;
            let estNumber;
            let check=false;
            $(function () {
                $('.chat-card').click(function () {
                    $('.right-box-info').empty();
                    $('.chat-card').removeClass('select');
                    $(this).addClass('select');
                    $('.chat-area').empty();
                    chatroomNo = $(this).find('.chatroomNo').val();
					$.ajax({
						url : "chatlist",
						data : {
                            chatroomNo : chatroomNo
						},
                        async:false,
						dataType:"json",
						success:function (data){
                            for (let i = 0; i < data.length; i++) {
								CheckLR(data[i]);
                            }
                            scrollToBottom();
						},
						error : function (){
                            console.log("채팅방 목록 불러오기 에러");
						}
					})
					
					if(${sessionScope.loginUser.userStatus == 2}){ <!-- 로그인 유저가 고수상태이면 회원 정보 붙이기 -->
                        $.ajax({
                            url : "chatUserInfo",
                            data : {
                                chatroomNo : chatroomNo
                            },
                            async:false,
                            dataType:"json",
                            success : function (data){
                               userNo = data.userNo;
									let userInfo =
										'<div class="info-profile">'
											+'<img class="info-profile-img" src="'+data.userProFile+'">'
											+'<img class="info-profile-more" src="<%=request.getContextPath()%>/resources/images/common/info-more.png">'
											+'<div clas="info-profile-more-list">'
												+'<div>회원 상세 조회</div>'
											+'</div>'
											+'<h3>'+ data.userName +'</h3>'
											+'<table>'
												+'<tr>'
													+'<td width="40%">지역</td>'
													+'<td>'+data.address+'</td>'
												+'</tr>'
												+'<tr>'
													+'<td>믿고 횟수</td>'
													+'<td>15 회</td>'
												+'</tr>'
											+'</table>'
											+'<hr style="border : 1px solid lightgray; width: 80%;">'
										+'</div>'
										+'<div class="info-detail">'
											+'<h5 style="margin-left: 20px">리뷰 목록</h5>'
											+'<div class="review-img-area">'
												+'<div style="width: 100px!important;"><img class="info-img" src="https://news.nateimg.co.kr/orgImg/xs/2020/04/09/1586412414197720.jpg"></div>'
												+'<div style="width: 100px!important;"><img class="info-img" src="https://post-phinf.pstatic.net/MjAyMTAyMjNfNDAg/MDAxNjE0MDY5MTYxNzE1.ID-uK_t73wGeNH9TGMIeWKJZsQq9KDg_nySZdlKTLBQg.eOm-EdEw-i_NbPvPA5qdAOeLpwlhqEu5PMVGu5DqXr8g.JPEG/4-2.jpg?type=w1200"></div>'
												+'<div style="width: 100px!important;"><img class="info-img" src="https://post-phinf.pstatic.net/MjAyMTAyMjNfNzQg/MDAxNjE0MDY5MTk5NDk2.RuWcBaRHnRUgGHlf-PHJAfsE54JjUD3DheHMskaeGsUg.wETZ4LxUQwZ6n6UErBz_2QqIATZk6sDvtx5bdlew304g.JPEG/5-3.jpg?type=w1200"></div>'
											+'</div>'
										+'</div>';
									$('.right-box-info').append(userInfo);
									$('.review-img-area').slick({
										slidesToShow: 2,
										slidesToScroll: 2,
									});
                            },
                            error : function () {
                                alert("오른쪽 회원 정보 조회 실패");
                            }
                        })
                    } else {			<!-- 로그인 유저가 회원 상태면 고수 정보 붙이기 -->
                        $.ajax({
                            url : "chatGosuInfo",
                            data : {
                                chatroomNo : chatroomNo
                            },
                            async:false,
                            dataType:"json",
                            success : function (data){
                                let member = data.member;
                                let gosu = data.gosu;
                                let chatReviewDtoList = data.chatReviewDtoList;
                                let gosuImgList = data.gosuImgList;
                                let serviceList = data.serviceList;
                                let pofolImgList = data.pofolImgList;
                                let userInfo =
                                    '<div class="info-profile">' +
										'<img class="info-profile-img" src="'+member.userProFile+'">' +
										'<img class="info-profile-more" src="<%=request.getContextPath()%>/resources/images/common/info-more.png">' +
										'<div class="info-profile-more-list">' +
											'<div>고수 상세 조회</div>' +
											'<div></div>' +
										'</div>' +
										'<h3>'+ member.userName +'</h3>'+
										'<table>' +
											'<tr>' +
												'<td width="30%">지역</td>' +
												'<td width="70%">대전 중구</td>' +
											'</tr>' +
											'<tr>' +
												'<td>리뷰</td>' +
												'<td>☆ '+ data.reviewAvg +' (' + chatReviewDtoList.length +')</td>' +
											'</tr>' +
											'<tr>' +
												'<td>경력</td>' +
												'<td>'+ gosu.career +'</td>' +
											'</tr>' +
										'</table>' +
										'<hr style="border: 1px solid lightgray; width: 80%;">' +
                                    '</div>' +
                                    '<div class="info-detail">' +
										'<div class="info-service">' +
										'<h5 style="margin-left: 20px">제공 서비스</h5>' +
										'<div class="info-service-list">';
								for (let i = 0; i < serviceList.length; i++) {
									userInfo += '<button class="meetgo-btn" value="'+ serviceList[i].categorySmallNo +'">'
									 + serviceList[i].categorySmallName
									+ '</button>'
								}
                                userInfo += '</div>' +
                                    '</div>' +
                                    '<h5 style="margin-left: 20px">소개 이미지</h5>' +
                                    '<div class="info-img-area">';
                                for (let i = 0; i < gosuImgList.length; i++) {
									userInfo += '<div style="width: 100px!important;"><img class="info-img" data-value="' +gosuImgList[i].gosuImgNo+ '" src="'+ gosuImgList[i].gosuImgUrl +'"></div>'
                                }
                                if(gosuImgList.length == 0) {
                                    userInfo += '<div style="width:100%!important;"><p style="margin-top: 20px; width: 100%">소개 이미지가 없습니다.</p></div>'
								}
								userInfo +=  '</div>' +
                                    '<h5 style="margin-left: 20px">포트폴리오</h5>' +
                                    '<div class="info-pofol">';
                                for (let i = 0; i < pofolImgList.length; i++) {
                                    userInfo += '<div style="width: 100px!important;"><img class="info-img" data-value="'+pofolImgList[i].pofolImgNo+'" src="'+pofolImgList[i].pofolImgUrl+'"></div>'
                                }
								userInfo += '</div>' +
                                    '</div>';
								$('.right-box-info').append(userInfo);

                                $('.info-pofol').slick({
                                    slidesToShow: 2,
                                    slidesToScroll: 2,
                                });
                                $('.review-img-area').slick({
                                    slidesToShow: 2,
                                    slidesToScroll: 2,
                                });
                                $('.info-img-area').slick({
                                    slidesToShow: 2,
                                    slidesToScroll: 2,
                                });
                            },
                            error : function () {
                                alert("오른쪽 고수 정보 조회 실패");
                            }
						})
                    }
					if(check) {
                        disconnect();
                    }
                    connect();
                    scrollToBottom();
                });
            });
		
            function CheckLR(data){
                const lr = (data.sender == ${sessionScope.loginUser.userNo}) ? "receiver" : "sender";
                appendChat(lr, data);
			}
            function appendChat(lr, data) {
                let chat = "";
                let est;
                let createAt = data.createAt;
                if (data.type == 'M') {
                    chat = '<div class="chat-bubble">'
								+ '<p class="'+lr+'">' + data.content +'</p>'
								+ '<p class="chat-createAt p-'+lr+'">'+data.createAt+'</p>'
							+ '</div>';
                    $('.chat-area').append(chat);
                    scrollToBottom();
                } else if (data.type == 'P') {
                    chat = '<div class="chat-bubble">'
							+ '<img class="'+lr+'" src="'+data.content+'">'
							+ '<p class="chat-createAt p-'+lr+'">'+data.createAt+'</p>'
                        + '</div>';
                    $('.chat-area').append(chat);
                    scrollToBottom();
                } else if (data.type == 'E') {
                    $.ajax({
						url : "searchEstimate",
						data : {
                            estimateNo : data.content
						},
						success : function (data) {
                            insertEstChat(data, lr,createAt);
						},
						error : function () {
      						console.log("견적서 채팅 입력 실패");
						}
					})
                
                } else {
                    console.log("채팅 타입 인식 실패")
				}
                scrollToBottom();
            }
            function insertEstChat(data, lr,createAt){
                let estStatus = data.status;
                let chat = '<div class="chat-bubble">'
					+ '<div class="chat-estimate '+lr+'">'
					+ '<h5 class="est-title">견적서</h5>'
					+ '<p class="est-content">'
						+ '고객님 안녕하세요. 요청서에 따른 예상금액입니다.'
					+ '</p>'
					+ '<hr>'
					+ '<table>'
						+ '<tr>'
							+ '<td>서비스</td>'
							+ '<td>' + data.estService + '</td>'
						+ '</tr>'
						+ '<tr>'
							+ '<th>예상 금액</th>'
							+ '<td>' + data.estPrice + '</td>'
						+ '</tr>'
					+ '</table>'
					+ '<hr>'
					+ '<div class="chat-est-button" id="est-btn-content'+data.estNo+'">';
  
                switch (estStatus) {<!-- 1:대기, 2:취소, 3:확정, 4:결제 완료, 5:완료 -->
					case '1' :
                        chat += '<button class="meetgo-btn"  style="width: 268px; margin: 5px; padding: 0; box-sizing: border-box">견적서 상세보기</button>' +
							'<div style="display: flex"><button class="meetgo-btn w-50 changeEstBtn" onclick="changeEstStatus('+data.estNo+', 3)">확정하기</button>' +
							'<button class="meetgo-btn meetgo-red w-50 changeEstBtn" onclick="changeEstStatus('+data.estNo+', 2)">취소하기</button></div>'
						break;
					case '2' :
                        chat += '<p>취소된 견적서 입니다.</p>'
                        break;
					case '3' :
                        chat += '<p>확정된 견적서 입니다.</p>'
							+ '<div style="display: flex">'
							+ '<button class="meetgo-btn w-50" onclick="">결제하기</button>'
							+ '<button class="meetgo-btn meetgo-red w-50 changeEstBtn"  onclick="changeEstStatus('+data.estNo+', 2)" style="width: 268px; margin: 5px; ">취소하기</button>'
                        break;
					case '4' :
                        chat += '<p>취소된 견적서 입니다.</p>'
                        break;
					case '5' :
                        chat += '<p>거래 완료된 견적서 입니다.</p>'
						+'<div style="display: flex"><button class="meetgo-btn w-50">견적 상세보기</button><button class="meetgo-btn w-50">리뷰 남기기</button></div>'
                        break;
				}
                chat += '</div>'
                    + '</div>'
                    + '<p class="chat-createAt p-' + lr + '">' + createAt +'</p>'
                    + '</div>';
                $('.chat-area').append(chat);
                scrollToBottom();
			}
		</script>
	</div>
	
	<div class="overlay-right-box">
		<div class="right-box">
			<div class="hide-right-box">
				<div style="">
					<img style="width: 100px; height: 100px" src="<%=request.getContextPath()%>/resources/images/chat/chat-icon.png">
					<div><p style="font-size: 30px; color: white">채팅을 선택해 주세요</p></div>
				</div>
			</div>
			<div style="display: flex; height: 85%">
				<div class="chat-area" id="chatArea" > <!-- 채팅 들어가는 영역 -->
				</div>
				<script>
					function scrollToBottom() {
						var chatArea = document.getElementById('chatArea');
						chatArea.scrollTop = chatArea.scrollHeight;
					}
					$(function (){
						scrollToBottom();
					})
				</script>
				<div class="right-box-info">

				</div>
			</div>
			<div>
				<script>
					$(function (){
						let chatbox = document.getElementsByClassName('chat-input-box');
						chatbox.disable = true;
					})
				</script>
				<div class="chat-input-box" >
					<label for="chat-textarea"></label>
					<textarea id="chat-textarea" maxlength="180" placeholder="메세지를 입력해 주세요."></textarea>
					<div>
						<div class="input-icon">
							<input type="file" id="chat-file" name="file" style="display: none" onchange="setChatImg(event);">
							<button class="meetgo-btn" id="chat-file-upload"><img src="<%=request.getContextPath()%>/resources/images/chat/img-icon.png" alt="">사진 첨부</button>
							<button class="meetgo-btn" id="chat-estimate-button"><img src="<%=request.getContextPath()%>/resources/images/chat/img-icon.png" alt="">견적서 첨부</button>
						</div>
						<div class="input-button">
							<button id="send-message-btn" onclick="sendMessage('M')" class="meetgo-btn">전송</button>
							<button class="meetgo-btn">채팅방 나가기</button>
						</div>
					</div>
				</div>
				<script>
					$('#chat-file-upload').click(function (e){
						$('#chat-file').click();
					});
					$('#chat-estimate-button').click(function () {
						$('#modalWrap').css("display","block");
					});
					function setChatImg(event) {
						var reader = new FileReader();
						$('.preview-img').remove();
						reader.onload = function(event) {
							var img = document.createElement("img");
							let imgArea = '<div class="preview-img">'
									+ '<img class="preview-img-close" onclick="previewClose()" src="<%=request.getContextPath()%>/resources/images/chat/close-icon.png"></div>';
							img.setAttribute("src", event.target.result);
							$('.chat-area').append(imgArea);
							document.querySelector(".preview-img").appendChild(img);
							$('#send-message-btn').attr('onclick', "sendMessage('P')");
					};
						
						reader.readAsDataURL(event.target.files[0]);
					}
					function previewClose(){
						$('.preview-img').remove();
						$('#send-message-btn').attr('onclick', "sendMessage('M')");
					}
				</script>
				
				<script>
					let websocket; // 전역변수 선언
					function connect(){
						check = true;
						let url = "ws://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/chat.do";
						websocket = new WebSocket(url);
						
						// 웹 소켓에 이벤트가 발생했을 때 호출될 함수 등
						websocket.onopen = onOpen;
						websocket.onmessage = onMessage;
					}
					function disconnect(){
						websocket.close();
					}
	
					// 웹 소켓에 연결되었을 때 호출될 함수
					function onOpen() {
						const data = {
							"chatroomNo" : chatroomNo,
							"sender" : ${sessionScope.loginUser.userNo},
							"type" : 'M',
							"content"   : "ENTER_CHAT",
							"createAt" : "<%= new SimpleDateFormat("yy-MM-dd HH:mm").format(new java.sql.Date(System.currentTimeMillis()))%>"
						};
						let jsonData = JSON.stringify(data);
						websocket.send(jsonData);
					}
	
					// * 1 메시지 전송
					function sendMessage(type){
						let jsonData;
						if(type == 'M'){ // 메시지일 경우
							let message = $('#chat-textarea').val();
							const data = {
								"chatroomNo" : chatroomNo,
								"sender" : ${sessionScope.loginUser.userNo},
								"type" : 'M',
								"content"   : message,
								"createAt" : "<%= new SimpleDateFormat("yy-MM-dd HH:mm").format(new java.sql.Date(System.currentTimeMillis()))%>"
							};
							jsonData = JSON.stringify(data);
							$('#chat-textarea').val('');
							websocket.send(jsonData);
						} else if (type == 'P') { // 사진일 경우
							console.log("채팅 메세지 전송");
							var form = $('#chat-file')[0].files[0];
							var formData = new FormData();
							formData.append('chatImg', form);
							formData.append('uNo', ${sessionScope.loginUser.userNo});
							formData.append('cNo', chatroomNo);
							$.ajax({
								type: "POST",
								enctype: 'multipart/form-data',
								url: "uploadChatImg",
								data: formData,
								processData: false,
								contentType: false,
								cache: false,
								success: function (result) {
									const data = {
										"chatroomNo" : chatroomNo,
										"sender" : ${sessionScope.loginUser.userNo},
										"type" : 'P',
										"content"   : result,
										"createAt" : "<%= new SimpleDateFormat("yy-MM-dd HH:mm").format(new java.sql.Date(System.currentTimeMillis()))%>"
	
									};
									jsonData = JSON.stringify(data);
									websocket.send(jsonData);
								},
								error: function (e) {
									alert("실패");
								}
							});
							$('.preview-img').remove();
							$('#send-message-btn').attr('onclick', "sendMessage('M')");
							
							
						} else if (type == 'E') { // 견적서 일경우
							const data = {
								"chatroomNo" : chatroomNo,
								"sender" : ${sessionScope.loginUser.userNo},
								"type" : 'E',
								"content"   : estNo,
								"createAt" : "<%= new SimpleDateFormat("yy-MM-dd HH:mm").format(new java.sql.Date(System.currentTimeMillis()))%>"
	
							};
							jsonData = JSON.stringify(data);
							websocket.send(jsonData);
						}
					}
	
					// * 2 메세지 수신
					function onMessage(e) {
						let obj = JSON.parse(e.data);
						let data = {
							"chatroomNo" : obj.chatroomNo,
							"sender" : obj.sender,
							"type" : obj.type,
							"content"   : obj.content,
							"createAt" : obj.createAt
						}
						CheckLR(data);
					}
					function changeEstStatus(changeEstNo, changeStatus){
						let estBtnContent = '#est-btn-content'+changeEstNo;
					   $(estBtnContent).empty();
						$.ajax({
							url : "changeEstStatus",
							data : {
								estNo : changeEstNo,
								status : changeStatus
							},
							success : function (result) {
								console.log(result);
								let chat = "";
								switch (result.status) {<!-- 1:대기, 2:취소, 3:확정, 4:결제 완료, 5:완료 -->
									case '1' :
										chat += '<button class="meetgo-btn"  style="width: 268px; margin: 5px; padding: 0; box-sizing: border-box">견적서 상세보기</button>' +
											'<div style="display: flex"><button class="meetgo-btn w-50" onclick="changeEstStatus('+result.estNo+', 3)">확정하기</button>' +
											'<button class="meetgo-btn meetgo-red w-50" onclick="changeEstStatus('+result.estNo+', 2)">취소하기</button></div>'
										break;
									case '2' :
										chat += '<p>취소된 견적서 입니다.</p>'
										break;
									case '3' :
										chat += '<p>확정된 견적서 입니다.</p>'
											+ '<div style="display: flex">'
											+ '<button class="meetgo-btn w-50" onclick="">결제하기</button>'
											+ '<button class="meetgo-btn meetgo-red w-50"  onclick="changeEstStatus('+result.estNo+', 2)" style="width: 268px; margin: 5px; ">취소하기</button>'
										break;
									case '4' :
										chat += '<p>취소된 견적서 입니다.</p>'
										break;
									case '5' :
										chat += '<p>거래 완료된 견적서 입니다.</p>'
											+'<div style="display: flex"><button class="meetgo-btn w-50">견적 상세보기</button><button class="meetgo-btn w-50">리뷰 남기기</button></div>'
										break;
								}
								$(estBtnContent).append(chat);
							},
							error : function () {
								console.log("견적서 상태 변경 실패");
							}
						})
					}
				</script>
				
			</div>
		</div>
	</div>
</div>

</body>
</html>
