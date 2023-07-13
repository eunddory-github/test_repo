package com.exam.error;

import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController 
public class errorHandler implements ErrorController {

	// private final Logger logger = (Logger) LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value = "/error") 
	public ModelAndView handleError(HttpServletResponse response) {

		int statusCode = response.getStatus();					// 에러코드 획득
		HttpStatus httpStatus = HttpStatus.valueOf(statusCode);	// 에러코드 상태정보
        
		if (statusCode > 0) {
			if (statusCode == HttpStatus.NOT_FOUND.value()) {			//404
				ModelAndView model = new ModelAndView();
				model.addObject("code", statusCode);
				model.addObject("msg", httpStatus.getReasonPhrase());
				model.addObject("timestamp",  new Date());
				model.setViewName("error/404");
				
				return model;	 
			}
			if (statusCode == HttpStatus.INTERNAL_SERVER_ERROR.value()) {   // 500 error
				return new ModelAndView("error/500");
			}	
		}
		// 나머지 모든 에러  
		return new ModelAndView("error/etc");
	}	

}