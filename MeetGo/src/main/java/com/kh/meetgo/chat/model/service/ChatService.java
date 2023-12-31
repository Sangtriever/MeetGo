package com.kh.meetgo.chat.model.service;

import com.kh.meetgo.chat.model.dto.ChatListDto;
import com.kh.meetgo.chat.model.dto.ChatReviewDto;
import com.kh.meetgo.chat.model.vo.Chat;
import com.kh.meetgo.chat.model.vo.Chatroom;
import com.kh.meetgo.gosu.model.vo.*;
import com.kh.meetgo.member.model.vo.Gosu;
import com.kh.meetgo.member.model.vo.Member;

import java.util.ArrayList;
import java.util.Map;

public interface ChatService {
    ArrayList<ChatListDto> selectChatroomList(Member m, String type);

    ArrayList<Chat> selectChatList(int roomNo);

    Chatroom selectChatroom(int chatroomNo);

    int insertChat(Chat chat);

    Member selectChatUserInfo(String chatroomNo);

    int insertEstimate(Estimate estimate);

    Estimate searchEstimate(int estNo);

    ArrayList<CategorySmall> selectAllCategory(String gosuNo);

    String selectService(int categorySmallNo);

    int insertChatImg(Chat chat);

    int changeEstStatus(Estimate estimate);

    Member selectChatGosuInfo(int chatroomNo);


    ArrayList<CategorySmall> selectServiceList(int userNo);

    Gosu selectGosu(int userNo);

    ArrayList<GosuImg> selectGosuImg(int userNo);

    ArrayList<ChatReviewDto> selectReviewList(int userNo);

    ArrayList<PofolImg> selectPofolList(int userNo);

    double selectReviewAvg(int userNo);

    int updateChatRead(Map<String, Object> params);

    int insertChatRoom(Chatroom chatroom);


    Chatroom checkChatRoom(Map<String, Integer> params);

    int changeAllEstStatus(Estimate estimate);

    ArrayList<ChatReviewDto> selectUserReviewList(int userNo);

    int outChatRoom(Map<String, Object> map);
}
