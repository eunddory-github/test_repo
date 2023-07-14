package com.exam;


import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Controller; 
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.exam.board.service.boardSerivce;
import com.exam.page.entity.criteria;
import com.exam.page.entity.pageVO;


// @ComponentScan(basePackages = {"com.example.board.controller","dto","mapper"})
@Controller
@SpringBootApplication
public class MyBoardApplication {
 
	@Autowired 
	private boardSerivce service;
	 
	@RequestMapping("/")
	public String mainPage(criteria cri, Model model) {
				
			pageVO pvo = new pageVO(); 
			pvo.setCri(cri); 
			pvo.setTotalCount(service.totalCnt()); 		// caldata() 페이징처리
			
			model.addAttribute("totalCnt",  service.totalCnt());
			model.addAttribute("list", service.getAllList(cri));
			model.addAttribute("pageVO", pvo);
			
			return "board/list";     
		}
	
	public static void main(String[] args) {
		SpringApplication.run(MyBoardApplication.class, args);
		
		
	}

}
