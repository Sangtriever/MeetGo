package com.kh.meetgo.chat.model.dao;

import com.kh.meetgo.chat.model.dto.ChatListDto;
import com.kh.meetgo.chat.model.dto.ChatReviewDto;
import com.kh.meetgo.chat.model.dto.GosuProfileDto;
import com.kh.meetgo.chat.model.vo.Chat;
import com.kh.meetgo.chat.model.vo.Chatroom;
import com.kh.meetgo.gosu.model.vo.*;
import com.kh.meetgo.member.model.vo.Gosu;
import com.kh.meetgo.member.model.vo.Member;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.Map;

@Repository
public class ChatDao {
    public ArrayList<ChatListDto> selectChatroomList(SqlSessionTemplate sqlSession, Member m) {
        return (ArrayList) sqlSession.selectList("chatMapper.selectChatRoomList", m);
    }

    public ArrayList<Chat> selectChatList(SqlSessionTemplate sqlSession, int chatroomNo) {
        return (ArrayList) sqlSession.selectList("chatMapper.selectChatList", chatroomNo);
    }

    public Chatroom selectChatroom(SqlSessionTemplate sqlSession, int chatroomNo) {
        return sqlSession.selectOne("chatMapper.selectChatroom", chatroomNo);
    }

    public int insertChat(SqlSessionTemplate sqlSession, Chat chat) {
        if(chat.getType().equals("M")){
            chat.setContent(changeTagMethod(chat.getContent()));
        }
        return sqlSession.insert("chatMapper.insertChat", chat);
    }
    public String changeTagMethod(String message) {

        String rtnStr = null;
        StringBuffer strTxt = new StringBuffer("");
        char chrBuff;
        int len = message.length();
        for(int i = 0; i < len; i++) {
            chrBuff = (char)message.charAt(i);
            switch(chrBuff) {
                case '<': strTxt.append("&lt;"); break;
                case '>': strTxt.append("&gt;"); break;
                case '&': strTxt.append("&amp;"); break;
                default:
                    strTxt.append(chrBuff);
            }
        }
        rtnStr = strTxt.toString();
        return rtnStr;
    }

    public Member selectChatUserInfo(SqlSessionTemplate sqlSession, String no) {
        int chatroomNo = Integer.parseInt(no);
        return sqlSession.selectOne("memberMapper.selectChatUserInfo", chatroomNo);
    }

    public int insertEstimate(SqlSessionTemplate sqlSession, Estimate estimate) {
        return sqlSession.insert("chatMapper.insertEstimate", estimate);
    }

    public Estimate searchEstimate(SqlSessionTemplate sqlSession, int estNo) {
        return sqlSession.selectOne("chatMapper.searchEstimate", estNo);
    }

    public ArrayList<CategorySmall> selectAllCategory(SqlSessionTemplate sqlSession, String gosuNumber) {
        int gosuNo = Integer.parseInt(gosuNumber);
        return (ArrayList) sqlSession.selectList("chatMapper.selectAllCategory", gosuNo);
    }

    public String selectService(SqlSessionTemplate sqlSession, int categorySmallNo) {
        return sqlSession.selectOne("chatMapper.selectService", categorySmallNo);
    }

    public int insertChatImg(SqlSessionTemplate sqlSession, Chat chat) {
        return sqlSession.insert("chatMapper.insertChatImg", chat);
    }

    public int changeEstStatus(SqlSessionTemplate sqlSession, Estimate estimate) {
        return sqlSession.update("chatMapper.changeEstStatus", estimate);
    }

    public Member selectChatGosuInfo(SqlSessionTemplate sqlSession, int chatroomNo) {
        return sqlSession.selectOne("chatMapper.selectChatGosuInfo", chatroomNo);
    }

    public ArrayList<CategorySmall> selectServiceList(SqlSessionTemplate sqlSession, int userNo) {
        return (ArrayList) sqlSession.selectList("chatMapper.selectServiceList", userNo);
    }

    public Gosu selectGosu(SqlSessionTemplate sqlSession, int userNo) {
        return sqlSession.selectOne("chatMapper.selectGosu", userNo);
    }

    public ArrayList<GosuImg> selectGosuImg(SqlSessionTemplate sqlSession, int userNo) {
        return (ArrayList) sqlSession.selectList("chatMapper.selectGosuImg", userNo);
    }

    public ArrayList<ChatReviewDto> selectReviewList(SqlSessionTemplate sqlSession, int userNo) {
        return (ArrayList) sqlSession.selectList("chatMapper.selectReviewList", userNo);
    }

    public ArrayList<PofolImg> selectPofolList(SqlSessionTemplate sqlSession, int userNo) {
        return (ArrayList) sqlSession.selectList("chatMapper.selectPofolList", userNo);
    }

    public double selectReviewAvg(SqlSessionTemplate sqlSession, int userNo) {
        return sqlSession.selectOne("chatMapper.selectReviewAvg", userNo);
    }

    public int updateChatRead(SqlSessionTemplate sqlSession, Map<String, Object> params) {
        return sqlSession.update("chatMapper.updateChatRead", params);
    }

    public int insertChatRoom(SqlSessionTemplate sqlSession, Chatroom chatroom) {
        return sqlSession.insert("chatMapper.insertChatRoom", chatroom);
    }

    public Chatroom checkChatRoom(SqlSessionTemplate sqlSession, Map<String, Integer> params) {
        return sqlSession.selectOne("chatMapper.checkChatRoom", params);
    }

    public int changeAllEstStatus(SqlSessionTemplate sqlSession, Estimate estimate) {
        return sqlSession.update("chatMapper.changeAllEstStatus", estimate);
    }

    public ArrayList<ChatReviewDto> selectUserReviewList(SqlSessionTemplate sqlSession, int userNo) {
        return (ArrayList)sqlSession.selectList("chatMapper.selectUserReviewList", userNo);
    }

    public int outChatRoom(SqlSessionTemplate sqlSession, Map<String, Object> map) {
        return sqlSession.update("chatMapper.outChatRoom", map);
    }
}
