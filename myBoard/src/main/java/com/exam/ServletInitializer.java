package com.exam;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

public class ServletInitializer extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(MyBoardApplication.class);
	}  
	/*
	 * ServletInitializer 클래스는 Spring Boot 애플리케이션을 WAR 파일로 패키징하여
	 * 외부 서블릿 컨테이너에 배포할 때 사용되는 클래스. 
	 * 
	 * Spring Boot는 기본적으로 내장형 서블릿 컨테이너(Tomcat)를 사용하여 애플리케이션을 실행.
	 * 그러나 WAR 파일로 애플리케이션을 패키징하여 외부 서블릿 컨테이너에 배포해야 하는 경우에는 ServletInitializer 클래스를 사용
	 * 
	 * ServletInitializer 클래스는 SpringBootServletInitializer 클래스를 상속하고, 
	 * configure() 메서드를 오버라이드하여 Spring Boot 애플리케이션의 설정을 구성.
	 * configure() 메서드는 외부 서블릿 컨테이너에서 애플리케이션을 실행할 때 호출되며, SpringApplicationBuilder를 사용하여 
	 * 애플리케이션의 설정 클래스(MyBoardApplication 클래스)를 지정함.
	 * 
	 * 즉, ServletInitializer 클래스는 WAR 파일로 패키징하여 외부 서블릿 컨테이너에 배포할 때 Spring Boot 애플리케이션의 초기화를 위한 역할을 한다.
	 *
	 */

}
