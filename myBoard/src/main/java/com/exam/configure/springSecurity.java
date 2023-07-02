package com.exam.configure;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

// 페이지 권한을 위한 클래스
@Configuration
@EnableWebSecurity	 //spring security 를 적용한다는 Annotation
public class springSecurity extends WebSecurityConfigurerAdapter {
 
	/** 
	 * passwordEncoger interface 의 구현체가 BCryptPasswordEncoder 임을 빈으로 등록해서 명시
	 **/
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	/**
	 *  규칙설정
	 **/
	@Override
	protected void configure(HttpSecurity http) throws Exception {
	http
	    .cors().disable()		// cors방지
	    .csrf().disable()		// 사이트 간 요청 위조(Cross-Site Request Forgery) 공격 방지 기능 키기
	    .formLogin().disable()	// 기본 로그인 페이지 없애기
	    .headers().frameOptions().disable();	
	}	
	
}
/**
 *  param : http , throw Exception
    
    .authorizeRequests()
	            .antMatchers( "/user/login", "/user/reqLogin").permitAll()	 // 로그인 권한 all
	            .and()
	        .formLogin()
	            .loginPage("/user/login")						// 로그인페이지
	            .loginProcessingUrl("/user/reqLogin")			// 로그인 요청 url
	            .defaultSuccessUrl("/board/list")				// 로그인 성공 시, 보여주는 화면 url
	            .failureUrl("/user/login") 						// 로그인 실패했을 때 보여주는 화면 url, 로그인 form으로 파라미터값 error=true로 보낸다.
	            .and()
	        .csrf().disable()		//사이트 간 요청 위조(Cross-Site Request Forgery) 공격 방지 기능 키기
	        .cors().disable();		//cors방지
}
 **/

	