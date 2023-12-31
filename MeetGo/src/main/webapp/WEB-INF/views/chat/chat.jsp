<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<title>채팅</title>
	
	<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
	
	<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
	<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
	<link href="<%=request.getContextPath()%>/resources/css/chat/chat.css?after" rel="stylesheet" type="text/css">
	
	
	<style>
        .preview-img {
            position: absolute;
            background-color: #939393;
            width: 650px;
            height: 400px;
            top: 278px;
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

        .overlay-right-box {
            position: relative;
        }

        .hide-all-content {
            position: absolute;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.9);
            z-index: 999;

        }

        .hide-all-content-area {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            text-align: center;
            line-height: 100%;
        }

        #image-detail {
            max-width: 1200px;
            max-height: 800px;
            object-fit: cover;
            vertical-align: middle;
            margin: auto;
        }

        .hide-right-box {
            position: absolute;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            text-align: center;
            align-items: center;
            padding-top: 30%;
        }

        #close-icon {
            position: absolute;
            width: 50px;
            height: 50px;
            right: 70px;
            top: 70px;
            cursor: pointer;
            color: whitesmoke;
        }
        
        .checkMark {
            width: 20px;
            height: 20px;
            margin: 0 5px 20px 5px !important;
        }
		.unReadCnt {
            background-color: red;
            color: white !important;
            border-radius: 50%;
            text-align: center;
            display: inline-block;
            width: 20px;
			
            height: 20px;
            line-height: 20px;
            margin: 0;
		}
		.checkGosu {
			
		}
	</style>
</head>
<body style="position: relative; height: 100%">
<script>
    let chatroomNo;
    let userNo;
    let estNo;
    let estNumber;
    let chatroomId;
    let check = false;
    let checkGosu;
    $(function () {
        checkGosu = (${sessionScope.loginUser.userStatus == 2} ? true:false);
        selectChatList("all");
    });
</script>
<div class="hide-all-content display-none">
	<div class="hide-all-content-area">
		<img id="close-icon" src="<%=request.getContextPath()%>/resources/images/chat/close-icon.png">
		<img id="image-detail" src="">
	</div>
	<script>
        $(window).click(function (e) {
            if (e.target.classList.contains('hide-all-content')) {
                $('.hide-all-content').addClass("display-none");
                $('#image-detail').attr("src", "");
            }
        });

        $('#close-icon').click(function () {
            $('.hide-all-content').addClass("display-none");
            $('#image-detail').attr("src", "");
        });
	</script>
</div>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="estimateForm.jsp"/>
<jsp:include page="estimateDetail.jsp"/>

<div class="chat-content">
	<div class="left-box">
		<div class="left-box-input-search">
			<div class="view-type" id="view-type" data-toggle="collapse" data-target="#type-collapse">
				<input type="hidden" id="chat-view-type" value="${requestScope.type}">
				<div style="width: 80%; text-align: center">
					<c:choose>
						<c:when test="${requestScope.type == 'noRead'}">
							안 읽은 채팅
						</c:when>
						<c:otherwise>
							최신순
						</c:otherwise>
					</c:choose>
				</div>
				
				<img src="<%=request.getContextPath()%>/resources/images/chat/wing-icon.png"
					 style="width: 50px; height: 50px">
			</div>
			<div class="chat-search-input display-none" id="search-type">
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

            chatSearch.addEventListener('click', function () {
                searchIcon.classList.toggle('display-none');
                closeIcon.classList.toggle('display-none');
                viewType.classList.toggle('display-none');
                searchType.classList.toggle('display-none');
            });
		</script>
		<div id="type-collapse" class="collapse">
			<a onclick='selectChatList("all", "")'>최신순</a>
			<a onclick='selectChatList("noRead", "")'>안 읽은 채팅</a>
		</div>
		<script>
            var links = document.querySelectorAll('#type-collapse a');
            links.forEach(function (link) {
                link.addEventListener('mouseover', function () {
                    this.style.backgroundColor = 'lightgray';
                });
                link.addEventListener('mouseout', function () {
                    this.style.backgroundColor = '';
                });
            });
		</script>
		<script>
            function gosuClick(gno){
                window.open('gosuDetail.go?gno='+gno, '_blank');
            }
            function clearChatList() {
				$('.left-box-chatList').empty();
            }

            function selectChatList(type , chatroomId) {
                clearChatList();
                $.ajax({
                    url: "chatroomList",
                    method: "get",
                    dataType: "json",
                    headers: {
                        "Content-Type": "application/json"  //전달하는 데이터가 JSON형태임을 알려줌
                    },
                    data: {
                        type: type,
                        userNo: '${sessionScope.loginUser.userNo}',
                        userStatus: '${sessionScope.loginUser.userStatus}'
                    },
                    success: function (roomList) {
                        for (let i = 0; i < roomList.length; i++) {
                            let chat = '';
                            if("chatroomId"+roomList[i].chatroom.chatroomNo == chatroomId){
                                chat += '<div class="chat-card select" id="chatroomId' + roomList[i].chatroom.chatroomNo + '">';
                            } else {
                                chat += '<div class="chat-card" id="chatroomId' + roomList[i].chatroom.chatroomNo + '">';
                            }
								chat +=
									'<input type="hidden" class="chatroomNo" value="' + roomList[i].chatroom.chatroomNo + '">' +
									'<div class="chat-card-img">' +
									'<img src="' + roomList[i].userProfile + '">' +
									'</div>' +
									'<div class="chat-card-info" style="width: 200px">' +
									'<div style="display: flex; justify-content: space-between;">' +
										'<p align="left">' + roomList[i].userName + '</p>';
								if(roomList[i].unReadCnt > 0){
                                    chat += '<p class="unReadCnt" align="right">' + roomList[i].unReadCnt + '</p>';
                                }
								chat +=	'</div>';
                            if (roomList[i].chat != null) {
                                if (roomList[i].chat.type == null) {
                                    chat += '<p></p>';
                                } else if (roomList[i].chat.type == 'P') {
                                    chat += '<p>사진</p>';
                                } else if (roomList[i].chat.type == 'E') {
                                    chat += '<p>계약서</p>';
                                } else {
                                    let chatContent = roomList[i].chat.content.length > 11 ? roomList[i].chat.content.substring(0, 10) + ".." : roomList[i].chat.content;
                                    chat += '<p>' + chatContent + '</p>';
                                }
                            } else {
                                chat += '<p></p>';
                            }
                            chat +=
                                '<p></p>' +
                                '</div>' +
                                '</div>';
                            $('.left-box-chatList').append(chat);
                        }
                    },
                    error: function () {
                        console.log("채팅 목록 조회 실패")
                    }
                })
            }
		</script>
		<div class="left-box-chatList">
		</div>
		
		<script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
		<script>
			function addChatList(chatroomNo){
                $('.chat-area').empty();
                $.ajax({
                    url: "chatlist",
                    data: {
                        chatroomNo: chatroomNo,
                        userNo: '${sessionScope.loginUser.userNo}'
                    },
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        for (let i = 0; i < data.length; i++) {
                            CheckLR(data[i]);
                        }
                        scrollToBottom();
                    },
                    error: function () {
                        console.log("채팅 목록 불러오기 에러");
                    }
                })
			}
            function reviewDetail(revNo){
                location.href = "reviewDetail.me?rno=" + revNo;
            }
            $(function () {
                $(document).on('click', '.chat-card', function () {
                    $('.hide-right-box').css("display", "none");
                    $('.right-box-info').empty();
                    $('.chat-card').removeClass('select');
                    chatroomId = $(this).attr("id");
                    console.log("chatroomId : " + chatroomId);
                    $('#'+chatroomId).addClass('select');
                    chatroomNo = $(this).find('.chatroomNo').val();

                    addChatList(chatroomNo);

                    if (${sessionScope.loginUser.userStatus == 2}) { <!-- 로그인 유저가 고수상태이면 회원 정보 붙이기 -->
                        $.ajax({
                            url: "chatUserInfo",
                            data: {
                                chatroomNo: chatroomNo
                            },
                            async: false,
                            dataType: "json",
                            success: function (data) {
                                userNo = data.member.userNo;
                                let member = data.member;
                                let revImgList = data.reviewImgList;
                                let targetUserNo = data.member.userNo;
                                let userInfo =
                                    '<div class="info-profile">'
                                    + '<img class="info-profile-img" src="' + member.userProFile + '">'
                                    + '<img class="info-report" onclick="reportAlert('+targetUserNo+')" src="<%=request.getContextPath()%>/resources/images/common/report-icon.png" >'
                                    + '<div clas="info-profile-more-list">'
                                    + '</div>'
                                    + '<h3>' + member.userName + '</h3>'
                                    + '<table>'
                                    + '<tr>'
                                    + '<td width="40%">지역</td>'
                                    + '<td>' + member.address + '</td>'
                                    + '</tr>'
                                    + '<tr>'
                                    + '<td>믿고 횟수</td>'
                                    + '<td>'+data.reviewCnt+' 회</td>'
                                    + '</tr>'
                                    + '</table>'
                                    + '<hr style="border : 1px solid lightgray; width: 80%;">'
                                    + '</div>'
                                    + '<div class="info-detail">'
                                    + '<h5 style="margin-left: 20px">리뷰 목록</h5>'
                                    + '<div class="review-img-area">';
								if(revImgList)
                                for (let i = 0; i < revImgList.length; i++) {
                                    userInfo +='<div style="width: 100px!important;"><img class="info-img" onclick="reviewDetail('+revImgList[i].review.revNo+')" src="'+revImgList[i].reviewImg.revImgUrl+'"></div>'
                                }
                                userInfo +=
									'</div>'
                                    + '</div>';
                                $('.right-box-info').append(userInfo);
                                
                                

                            },
                            error: function () {
                                alert("오른쪽 회원 정보 조회 실패");
                            }
                        })
                    } else {			<!-- 로그인 유저가 회원 상태면 고수 정보 붙이기 -->
                        $.ajax({
                            url: "chatGosuInfo",
                            data: {
                                chatroomNo: chatroomNo
                            },
                            async: false,
                            dataType: "json",
                            success: function (data) {
                                console.log(data);
                                let member = data.member;
                                let gosu = data.gosu;
                                let chatReviewDtoList = data.chatReviewDtoList;
                                let gosuImgList = data.gosuImgList;
                                let serviceList = data.serviceList;
                                let pofolImgList = data.pofolImgList;
                                
                                let userInfo =
                                    '<div class="info-profile">' +
                                    '<img class="info-profile-img" style="cursor : pointer" onclick="gosuClick('+data.gosu.gosuNo+')" id="gosu-profile-img" src="' + member.userProFile + '">' +
                                    '<img class="info-report" onclick="reportAlert('+gosu.gosuNo+')"  src="<%=request.getContextPath()%>/resources/images/common/report-icon.png">' +
                                    '<h3>' + member.userName + '</h3>' +
                                    '<table>' +
                                    '<tr>' +
                                    '<td width="30%">지역</td>' +
                                    '<td width="70%">'+gosu.region+'</td>' +
                                    '</tr>' +
                                    '<tr>' +
                                    '<td>리뷰</td>' +
                                    '<td>☆ ' + data.reviewAvg + ' (' + chatReviewDtoList.length + ')</td>' +
                                    '</tr>' +
                                    '<tr>' +
                                    '<td>경력</td>' +
                                    '<td>' + gosu.career + '</td>' +
                                    '</tr>' +
                                    '</table>' +
                                    '<hr style="border: 1px solid lightgray; width: 80%;">' +
                                    '</div>' +
                                    '<div class="info-detail">' +
                                    '<div class="info-service">' +
                                    '<div class="info-service-list">';
                                for (let i = 0; i < serviceList.length; i++) {
                                    userInfo += '<button class="meetgo-btn" value="' + serviceList[i].categorySmallNo + '">'
                                        + serviceList[i].categorySmallName
                                        + '</button>'
                                }
                                userInfo += '</div>' +
                                    '</div>' +
                                    '<h5 style="margin-left: 20px">소개 이미지</h5>' +
                                    '<div class="info-img-area">';
                                for (let i = 0; i < gosuImgList.length; i++) {
                                    userInfo += '<div style="width: 100px!important;"><img class="info-img show-detail-img" data-value="' + gosuImgList[i].gosuImgNo + '" src="' + gosuImgList[i].gosuImgUrl + '"></div>'
                                }
                                if (gosuImgList.length == 0) {
                                    userInfo += '<div style="width:100%!important;"><p style="margin-top: 20px; width: 100%">소개 이미지가 없습니다.</p></div>'
                                }
                                userInfo += '</div>' +
                                    '<h5 style="margin-left: 20px">포트폴리오</h5>' +
                                    '<div class="info-pofol">';
                                if (pofolImgList.length == 0) {
                                    userInfo += '<div style="width:100%!important;"><p style="margin-top: 20px; width: 100%">포트폴리오가 없습니다.</p></div>'
                                }
                                for (let i = 0; i < pofolImgList.length; i++) {
                                    userInfo += '<div style="width: 100px!important;"><img class="info-img" onclick="movePofol('+pofolImgList[i].pofolNo+')" data-value="' + pofolImgList[i].pofolImgNo + '" src="' + pofolImgList[i].pofolImgUrl + '"></div>'
                                }
                                userInfo += '</div>' +
                                    '</div>';
                                $('.right-box-info').append(userInfo);

								
                            },
                            error: function () {
                                alert("오른쪽 고수 정보 조회 실패");
                            }
                        })
                    }

                    $('.show-detail-img').click(function () {
                        $('#image-detail').attr("src", $(this).attr("src"));
                        $('.hide-all-content').removeClass('display-none');
                    });

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
                    if (check) {
                        disconnect();
                    }
                    connect();
                    scrollToBottom();
                });
            });

            function CheckLR(data) {
                const lr = (data.sender == ${sessionScope.loginUser.userNo}) ? "receiver" : "sender";
                appendChat(lr, data);
            }

            function appendChat(lr, data) {
                let chat = "";
                let est;
                let createAt = data.createAt;
				let chatRead = data.chatRead;
                let checkMarkUrl = "";
                console.log("!! chatRead : " + chatRead);
                if(chatRead == 0){
                    checkMarkUrl = '<img class="checkMark" src="' + '<%=request.getContextPath()%>' + '/resources/images/chat/question-icon.png">';
				}
                if (data.type == 'M') {
                    if (lr == "receiver") {
                        chat = '<div class="chat-bubble" style="justify-content: flex-end;" >'+checkMarkUrl+'';
                           chat += '<p class="chat-createAt">' + data.createAt + '</p>'
                            + '<p class="' + lr + '">' + data.content + '</p>'
                            + '</div>';
                    } else {
                        chat = '<div class="chat-bubble" style="">'
                            + '<p class="' + lr + '">' + data.content + '</p>'
                            + '<p class="chat-createAt">' + data.createAt + '</p>'
							+ ''+checkMarkUrl+''
							+ '</div>';
                    }
                    $('.chat-area').append(chat);
                    scrollToBottom();
                } else if (data.type == 'P') {
                    if (lr == "receiver") {
                        chat = '<div class="chat-bubble" style="justify-content: flex-end;">'
                            + ''+checkMarkUrl+''
                            + '<p class="chat-createAt">' + data.createAt + '</p>'
                            + '<img class="' + lr + '" src="' + data.content + '">'
                            + '</div>';
                    } else {
                        chat = '<div class="chat-bubble">'
                            + '<img class="' + lr + '" src="' + data.content + '">'
                            + '<p class="chat-createAt">' + data.createAt + '</p>'
                            + ''+checkMarkUrl+''
                            + '</div>';
                    }
                    $('.chat-area').append(chat);
                    scrollToBottom();
                } else if (data.type == 'E') {
                    $.ajax({
                        url: "searchEstimate",
                        async: false,
                        data: {
                            estimateNo: data.content
                        },
                        success: function (data) {
                            insertEstChat(data, lr, createAt,checkMarkUrl);
                        },
                        error: function () {
                            console.log("계약서 채팅 입력 실패");
                        }
                    })

                } else {
                    console.log("채팅 타입 인식 실패")
                }
                scrollToBottom();
            }

            function insertEstChat(data, lr, createAt, checkMarkUrl) {
                let estStatus = data.status;
                let chat = '';
                checkMarkUrl = checkMarkUrl=="" ? "" : '<img class="checkMark" style="margin-bottom:0px!important" src="' + '<%=request.getContextPath()%>' + '/resources/images/chat/question-icon.png">'
                if (lr == "receiver") {
                    chat += '<div class="chat-bubble" style="justify-content: flex-end;">'
						+ '<div class="est-read">'
						+ ''+checkMarkUrl+''
                    	+ '<p class="chat-createAt">' + createAt + '</p>'
						+ '</div>';
                } else {
                    chat += '<div class="chat-bubble">';
                }
                chat += '<div class="chat-estimate ' + lr + '">'
                    + '<h5 class="est-title">계약서</h5>'
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
                    + '<div class="chat-est-button" id="est-btn-content' + data.estNo + '">';

                switch (estStatus) {<!-- 1:대기, 2:취소, 3:확정, 4:결제 완료, 5:완료 -->
                    case '2' :
                        chat += '<button class="meetgo-btn est-detail-btn"  value="'+data.estNo+'"  style="width: 268px; margin: 5px; padding: 0; box-sizing: border-box">계약서 상세보기</button>' +
                            '<div style="display: flex"><button class="meetgo-btn w-50 changeEstBtn checkGosu" onclick="changeEstStatus(' + data.estNo + ', 3)">확정하기</button>' +
                            '<button class="meetgo-btn meetgo-red w-50 changeEstBtn" onclick="changeEstStatus(' + data.estNo + ', 1)">취소하기</button></div>'
                        break;
                    case '1' :
                        chat += '<p>취소된 계약서 입니다.</p>'
                        break;
                    case '3' :
                        chat += '<p>확정된 계약서 입니다.</p>'
							+ '<button class="meetgo-btn est-detail-btn"  value="'+data.estNo+'"  style="width: 268px; margin: 5px; padding: 0; box-sizing: border-box">계약서 상세보기</button>'
                            + '<div style="display: flex">'
                            + '<button class="meetgo-btn w-50" onclick="estDetailInfoKakao('+data.estNo+')">결제하기</button>'
                            + '<button class="meetgo-btn meetgo-red w-50 changeEstBtn"  onclick="changeEstStatus(' + data.estNo + ', 1)" style="width: 268px; margin: 5px; ">취소하기</button>' +
							'</div>'
                        break;
                    case '4' :
                        chat += '<p>결제 완료된 계약서 입니다.</p>'+
								'<div >' +
									'<button class="meetgo-btn w-100 est-detail-btn" value="'+data.estNo+'">계약 상세보기</button>' +
									'<button class="meetgo-btn w-100" onclick="completeContract('+data.estNo+')">서비스 완료하기</button>' +
								'</div>'
                        break;
                    case '5' :
                        chat += '<p>거래 완료된 계약서 입니다.</p>'
                            + '<div style="display: flex">' +
							'<button class="meetgo-btn w-50 est-detail-btn" value="'+data.estNo+'">계약 상세보기</button>' +
                            '<button class="meetgo-btn w-50" onclick="insertReview('+data.estNo+')">리뷰 남기기</button>' +
                            '</div>'
                        break;
                }
                chat += '</div>'
                    + '</div>';
                if (lr == "sender") {
                    chat +=  '<div class="est-read">'
						+ '<p class="chat-createAt">' + createAt
						+ '</p>'
						+ ''+checkMarkUrl+''
						+ '</div>';
                }
                chat += '</div>';
                $('.chat-area').append(chat);
                scrollToBottom();
            }
		</script>
	</div>
	<script>
		$(function (){
  
		})
	</script>
	<div class="overlay-right-box">
		<div class="right-box">
			<div class="hide-right-box">
				<div style="">
					<img style="width: 100px; height: 100px"
						 src="<%=request.getContextPath()%>/resources/images/chat/chat-icon.png">
					<div><p style="font-size: 30px; color: white">채팅을 선택해 주세요</p></div>
				</div>
			</div>
			<div style="display: flex; height: 85%">
				<div class="chat-area" id="chatArea"> <!-- 채팅 들어가는 영역 -->
				</div>
				<script>
                    function scrollToBottom() {
                        var chatArea = document.getElementById('chatArea');
                        chatArea.scrollTop = chatArea.scrollHeight;
                    }

                    $(function () {
                        scrollToBottom();
                    })
				</script>
				<div class="right-box-info">
				
				</div>
			</div>
			<div>
				<script>
                    $(function () {
                        let chatbox = document.getElementsByClassName('chat-input-box');
                        chatbox.disable = true;
                    })
				</script>
				<div class="chat-input-box">
					<label for="chat-textarea"></label>
					<textarea id="chat-textarea" maxlength="180" onkeyup="enterkey()" placeholder="메세지를 입력해 주세요."></textarea>
					<div>
						<div class="input-icon">
							<input type="file" id="chat-file" name="file" style="display: none"
								   onchange="setChatImg(event);">
							<button class="meetgo-btn" id="chat-file-upload"><img
									src="<%=request.getContextPath()%>/resources/images/chat/img-icon.png" alt="">사진 첨부
							</button>
							<c:if test="${sessionScope.loginUser.userStatus == 2}">
								<button class="meetgo-btn" id="chat-estimate-button"><img
										src="<%=request.getContextPath()%>/resources/images/chat/img-icon.png" alt="">계약서첨부
								</button>
							</c:if>
						</div>
						<div class="input-button">
							<button id="send-message-btn" onclick="sendMessage('M')" class="meetgo-btn">전송</button>
							<button class="meetgo-btn" onclick="deleteChat(chatroomNo)">채팅방 나가기</button>
						</div>
					</div>
				</div>
				<script>
                    function enterkey() {
                        if (window.event.keyCode == 13) {
                            $('#send-message-btn').click();
                        }
                    }
                    $('#chat-file-upload').click(function (e) {
                        $('#chat-file').click();
                    });
                    $('#chat-estimate-button').click(function () {
                        $('#modalWrapEstEnroll').css("display", "block");
                    });
                    $(document).on('click', '.est-detail-btn', function (){
                        console.log("click");
                        
                        estDetailInfo($(this).val());
                        $('#modalWrapDetail').css("display", "block");
                    });
                    function setChatImg(event) {
                        var reader = new FileReader();
                        $('.preview-img').remove();
                        reader.onload = function (event) {
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

                    function previewClose() {
                        $('.preview-img').remove();
                        $('#send-message-btn').attr('onclick', "sendMessage('M')");
                    }

                    function deleteChat(chatroomNo) {
                        if (!confirm("채팅방을 나가시겠습니까? 기존 대화 내역은 삭제됩니다.")) {
                            return;
                        }
                        $.ajax({
							url : "outChatRoom",
							method : "get",
							data : {
                                chatroomNo : chatroomNo
							},
							success : function (){
       							location.reload();
							},
							error : function (){
                                console.log("채팅방 나가기");
							}
						})
                    }
				</script>
				
				<script>
                    let websocket; // 전역변수 선언
                    function connect() {
                        check = true;
                        let url = "ws://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/chat.do";
                        websocket = new WebSocket(url);

                        // 웹 소켓에 이벤트가 발생했을 때 호출될 함수 등
                        websocket.onopen = onOpen;
                        websocket.onmessage = onMessage;
                    }

                    function disconnect() {
                        websocket.close();
                    }

                    // 웹 소켓에 연결되었을 때 호출될 함수
                    function onOpen() {
                        const data = {
                            "chatroomNo": chatroomNo,
                            "sender": ${sessionScope.loginUser.userNo},
                            "type": 'ENTER',
                            "content": "ENTER_CHAT",
                            "createAt": "<%= new SimpleDateFormat("yy-MM-dd HH:mm").format(new java.sql.Date(System.currentTimeMillis()))%>"
                        };
                        let jsonData = JSON.stringify(data);
                        websocket.send(jsonData);
                    }

                    // * 1 메시지 전송
                    function sendMessage(type) {
                        let jsonData;
                        if (type == 'M') { // 메시지일 경우
                            let message = $('#chat-textarea').val();
                            if (message.replaceAll(" ", "").length == 0) {
                                alert("메시지를 입력해 주세요");
                            } else {
                                const data = {
                                    "chatroomNo": chatroomNo,
                                    "sender": ${sessionScope.loginUser.userNo},
                                    "type": 'M',
                                    "content": message,
                                    "createAt": "<%= new SimpleDateFormat("yy-MM-dd HH:mm").format(new java.sql.Date(System.currentTimeMillis()))%>"
                                };
                                jsonData = JSON.stringify(data);
                                $('#chat-textarea').val('');
                                websocket.send(jsonData);
                            }
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
                                        "chatroomNo": chatroomNo,
                                        "sender": ${sessionScope.loginUser.userNo},
                                        "type": 'P',
                                        "content": result,
                                        "createAt": "<%= new SimpleDateFormat("yy-MM-dd HH:mm").format(new java.sql.Date(System.currentTimeMillis()))%>"

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


                        } else if (type == 'E') { // 계약서 일경우
                            const data = {
                                "chatroomNo": chatroomNo,
                                "sender": ${sessionScope.loginUser.userNo},
                                "type": 'E',
                                "content": estNo,
                                "createAt": "<%= new SimpleDateFormat("yy-MM-dd HH:mm").format(new java.sql.Date(System.currentTimeMillis()))%>"

                            };
                            jsonData = JSON.stringify(data);
                            websocket.send(jsonData);
                        }
                        setTimeout(function () {
                            if(chatroomId != ""){
                                clearChatList();
								selectChatList('${requestScope.type}', ("chatroomId"+chatroomNo));
                            }
                        }, 1000);

                    }

                    // * 2 메세지 수신
                    function onMessage(e) {
                        let obj = JSON.parse(e.data);
                        let data = {
                            "chatroomNo": obj.chatroomNo,
                            "sender": obj.sender,
                            "type": obj.type,
                            "content": obj.content,
                            "createAt": obj.createAt,
							"chatRead": obj.chatRead
                        }
                        console.log(data);
						if(data.type != "ENTER"){
                            CheckLR(data);
						}
                        if(data.sender != ${sessionScope.loginUser.userNo}){
                            addChatList(chatroomNo);
                        }
                    }
                    
                    function changeEstStatus(changeEstNo, changeStatus) {
                        if((changeStatus == 3 || changeStatus == 4) && ${sessionScope.loginUser.userStatus eq 2}){
                            alert("확정 버튼과 결제 버튼은 고객만 가능합니다.");
                            return;
                        }
                        if(changeStatus == 3 && !confirm("확정하면 남은 모든 견적서가 취소됩니다")){
                            return;
						}
                        let estBtnContent = '#est-btn-content' + changeEstNo;
                        console.log("eno : " + changeEstNo);
                        $(estBtnContent).empty();
                        $.ajax({
                            url: "changeEstStatus",
                            data: {
                                estNo: changeEstNo,
                                status: changeStatus
                            },
                            success: function (result) {
                                let chat = "";
                                switch (result.status) {<!-- 1:대기, 2:취소, 3:확정, 4:결제 완료, 5:완료 -->
                                    case '2' :
                                        chat += '<button class="meetgo-btn est-detail-btn" value="'+result.estNo+'" style="width: 268px; margin: 5px; padding: 0; box-sizing: border-box">계약서 상세보기</button>' +
                                            '<div style="display: flex"><button class="meetgo-btn w-50" onclick="changeEstStatus(' + result.estNo + ', 3)">확정하기</button>' +
                                            '<button class="meetgo-btn meetgo-red w-50" onclick="changeEstStatus(' + result.estNo + ', 1)">취소하기</button></div>'
                                        break;
                                    case '1' :
                                        chat += '<p>취소된 계약서 입니다.</p>'
                                        break;
                                    case '3' :
                                        chat += '<p>확정된 계약서 입니다.</p>'
                                            + '<div style="display: flex">'
                                            + '<button class="meetgo-btn w-50" onclick="estDetailInfoKakao('+result.estNo+')">결제하기</button>'
                                            + '<button class="meetgo-btn meetgo-red w-50"  onclick="changeEstStatus(' + result.estNo + ', 1)" style="width: 268px; margin: 5px; ">취소하기</button>'
                                        break;
                                    case '4' :
                                        chat += '<p>결제 완료된 계약서 입니다.</p>'+
                                            '<div style="display: flex">' +
                                            '<button class="meetgo-btn w-50 est-detail-btn" value="'+data.estNo+'">계약 상세보기</button>' +
                                            '<button class="meetgo-btn w-50" onclick="completeContract('+data.estNo+')">서비스 완료하기</button>' +
                                            '</div>'
                                        break;
                                    case '5' :
                                        chat += '<p>거래 완료된 계약서 입니다.</p>'
                                            + '<div style="display: flex">' +
											'<button class="meetgo-btn w-50 est-detail-btn" value="'+result.estNo+'">계약 상세보기</button>' +
                                            '<button class="meetgo-btn w-50" onclick="location.href=reviewWrite.me?eno=' + result.estNo + '">리뷰 남기기</button>' +
											'</div>'
                                        break;
                                }
                                const data = {
                                    "chatroomNo": chatroomNo,
                                    "sender": ${sessionScope.loginUser.userNo},
                                    "type": 'CHANGE',
                                    "content": 'CHANGE_ESTMATE',
                                    "createAt": "<%= new SimpleDateFormat("yy-MM-dd HH:mm").format(new java.sql.Date(System.currentTimeMillis()))%>"
                                };
                                let jsonData = JSON.stringify(data);
                                websocket.send(jsonData);
                                $('#'+chatroomId).click();
                            },
                            error: function () {
                                console.log("계약서 상태 변경 실패");
                            }
                        })
                    }
				</script>
			
			</div>
		</div>
	</div>
	<script>
        var scriptExecuted = false;
        $(document).ajaxStop(function () {
            <c:if test="${not empty requestScope.chatroomNo}">
			console.log("안비었다");
            if (!scriptExecuted) {
                $(document).ready(function () {
                    $('#chatroomId${requestScope.chatroomNo}').click();
                    scriptExecuted = true; // 스크립트 실행 완료 후 플래그를 true로 변경
                    <c:remove var="gno" scope="request" />
                });
            }
            </c:if>
        });
	
	</script>
	<script>
        function estDetailInfoKakao(estNo) {
            if(${sessionScope.loginUser.userStatus eq 2}){
                alert("확정 버튼과 결제 버튼은 고객만 가능합니다.");
                return;
            }
            $.ajax({
                url: "selectEst",
                data: {
                    estNo: estNo
                },
                success: function (data) {
                    kakaoPayment(data);
                    
                },
                error: function () {
                    console.log("견적서 상세조회 실패")
                }
            })
        }
        function kakaoPayment(estmate){
			$.ajax({
				url: 'kakaopay.me',
				method : 'post',
				dataType: 'json',
				data : {
					userNo : estmate.userNo,
					estTitle : estmate.estTitle,
					estPrice : estmate.estPrice,
					estNo : estmate.estNo
				},
				success: function(data){
					var box = data;
                    addChatList(chatroomNo);
					window.open(box);
				},
				error: function(){
					alert("카카오페이 ajax 실패");
				}
			});
        }
        

        function completeContract(estNo){
            if(!confirm("서비스 완료 후 취소할 수 없습니다. 완료하시겠습니까?")){
                return;
			}
			$.ajax({
				url: "complete.me",
				type: 'get',
				data : {
					estNo : estNo
				}, success : function(){
					addChatList(chatroomNo);
				}, error : function(){
					alert("서비스 완료 등록 오류! 관리자에게 문의하세요.");
				}
			});
        }
        function insertReview(estNo){
            location.href = "reviewWrite.me?eno=" + estNo;
        }
        function movePofol(pofolNo){
            window.open("pofolDetail.po?pno=" + pofolNo, '_blank');
        }
	</script>
</div>

</body>
</html>
