package com.exam;


import java.time.LocalDateTime;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;


// @ComponentScan(basePackages = {"com.example.board.controller","dto","mapper"})
@SpringBootApplication
public class MyBoardApplication {

	public static void main(String[] args) {
		SpringApplication.run(MyBoardApplication.class, args);
		
		
	}

}
