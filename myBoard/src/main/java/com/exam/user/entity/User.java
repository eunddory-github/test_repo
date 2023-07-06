package com.exam.user.entity;

import java.util.Collection;
import java.util.Collections;
import java.util.Date;

import javax.persistence.Id;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.jackson2.SimpleGrantedAuthorityMixin;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.security.crypto.password.PasswordEncoder;

@Data
@Getter
@ToString
public class User  {
	@Id
	private String id;					// 아이디 pk
		
	private String  userName;			// 이름 
	private String 	PassWord;			// 비밀번호
	private String  email;				// 이메일
	private String 	gender;				// 성별(1: 남, 2: 여)
	private String	phoneNumber;		// 휴대폰 번호
	
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private Date  	creatDt;		// 생성날짜


	 
}
