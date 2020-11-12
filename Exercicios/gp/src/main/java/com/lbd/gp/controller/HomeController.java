package com.lbd.gp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.lbd.gp.model.Prova;
import com.lbd.gp.repository.ProvaRepository;

@Controller
@RequestMapping("/")
public class HomeController {
	
	@Autowired
	private ProvaRepository provaRepository;
	
	@GetMapping
	public ModelAndView home() {
		ModelAndView mv = new ModelAndView("home");
		
		List<Prova> provas = provaRepository.findAll();
		mv.addObject("provas", provas);
		
		return mv;
	}	
	
}
