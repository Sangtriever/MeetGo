<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style> 
    @font-face {
        font-family: 'Pretendard-Regular';
        src: url('https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
        font-weight: 400;
        font-style: normal;
    }
    * { font-family: 'Pretendard-Regular'; 
    
    } 
    
    @import url("https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css");

    .wrap{
        margin: auto;
        width: 1000px;
        box-sizing: border-box;
    }
    .main_title{
    
        width: 100%;
        height: 50px;
        box-sizing: border-box;
    }
    .main_title_1{
        width: 70%;
        height: 50px;
        box-sizing: border-box;
        float: left;
    }
 
    .main_title_2 {
    width: 30%;
    height: 50px;
    box-sizing: border-box;
    float: right;
    display: flex;
    justify-content: center; /* 수평 가운데 정렬 */
    align-items: center; /* 수직 가운데 정렬 */
    
    }
    
    .main_body{
     width: 1000px;
     height: 950px;
    }

    .main_body_1{
        box-sizing: border-box;
        height: 50px;
        width: 100%;
    }
    .main_body_1_1{
        height: 50px;
        float: left;
        width: 80%;

    }
    
    .main_body_1_2{
        height: 50px;
        float: right;
        width: 20%;
    }

    .main_body_2_1{
        width: 1000px;
        height: 100px;
    }

    .main_body_3_1{
        width: 1000px;
        height: 600px;
        text-align: center;
       
    }
    .main_body_4 {
        width: 1000px;
        height: 65px; 
        float: left;   
        }
    .main_body_4_1{
        width: 70%;
        height: 100%;
        float: left;
    }   
    .main_body_4_2{
        width: 30%;
        height: 100%;
        float: right;
    }
    #category{
        height: 30px;
        width: 100px;
        display: flex;
        justify-content: center;
        align-items: center;
    
    }
    #titleImg {
    margin: auto; /* 가운데 정렬 스타일 추가 */
    display: block; /* 이미지를 블록 레벨 요소로 설정하여 가운데 정렬이 적용되도록 합니다. */
    }
    #textarea{
        resize: none;
        width: 800px;
        height: 300px;
        border-radius: 8px;
        margin: auto; /* 가운데 정렬 스타일 추가 */
        display: block; /* 블록 레벨 요소로 설정하여 가운데 정렬이 적용되도록 합니다. */
    }
    
    #tipImg {
    	
    }
    
    .report{
    	width: 50px;
    	height: 50px;
    	margin-right:20px;
    	margin-bottom: 15px;
    }
</style>
</head>
<body>
	<jsp:include page="../../common/header.jsp"/>
	<jsp:include page="../../common/side.jsp"/>
	
	<div class="wrap">
	<br>
        <div class="main_title" >
       		
       		<br>
            <div class="main_title_1" style="float: left;">
            <br>
            <h4 style="font-size:40px">&nbsp;&nbsp;&nbsp;
            ${ requestScope.m.boardTitle }
            </h4>
        
        	</div>
         
            
        </div>
        <br><br>
        <hr>
        <div>
        </div>
        
        <div class="main_body">
          
            <div class="main_body_1" style="width:100%;">
          
            <div class="main_body_1_1" style="width:50%; text-align:left;">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             &nbsp;&nbsp;
        		<img src="${ requestScope.m.userProfile }" id="profileImg" width="70" height="70"   style="border-radius: 50%;" >    
            &nbsp; ${ requestScope.m.userNickname } 
                 
             
            </div>
            
            <div class="main_body_1_2" style="width:50%;  text-align:right;" >
                &nbsp;  &nbsp; 
            	  작성일 :&nbsp; ${ requestScope.m.boardCreateDate } 
            	  &nbsp;  &nbsp;
            	  <i class="bi bi-eye-fill"></i>  &nbsp; ${ requestScope.m.boardCount } 
            </div>
            
            
            </div>
           

         <div class="main_body_3_1">
			    <br>
			     <img style="height: 250px; width:300px; align:center;" src="${ requestScope.dtoList[0].bfilePath }"> 
			
			    <br> <br>
			    
			    <p id="textarea" 
			    style="width:600px; height:250px; text-align:left; font-size:20px; background-color: transparent;" >${requestScope.m.boardContent}
			    </p>
			    
			    <hr>
			</div>
            <br>
         <div class="main_body_4">
            <div class="main_body_4_1">
            <c:if test="${sessionScope.loginUser.userNo eq requestScope.m.userNo }">
                &nbsp;&nbsp;
                <button class="btn btn-primary">수정하기</button> 
                &nbsp;&nbsp;
                <button class="btn btn-secondary" onclick="deleteboard('${ requestScope.m.boardNo }');">삭제하기</button>
            </c:if>
            

            
             </div>
            <div class="main_body_4_2">
                &nbsp;&nbsp; &nbsp;&nbsp;
                &nbsp;&nbsp; &nbsp;&nbsp;
                &nbsp;&nbsp; &nbsp;&nbsp;
                <img class="report" onclick="reportAlert('${requestScope.m.userNo}')" src="<%=request.getContextPath()%>/resources/images/common/report-icon.png">
                <button type="button" onclick="location.href='tipList.bo'" class="btn btn-primary">목록으로</button> 


            </div>
        
        </div>
        
    </div>
    </div>
    <script>
		function deleteboard(bno) {
			
			
			location.href = "deleteBoard.bo?bno=" + bno;
			
		}

    </script>
    
    <jsp:include page="../../common/footer.jsp"/>
    
</body>
</html>