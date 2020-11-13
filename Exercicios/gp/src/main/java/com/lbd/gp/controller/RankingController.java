package com.lbd.gp.controller;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.lbd.gp.dao.RankingDAO;
import com.lbd.gp.model.Prova;
import com.lbd.gp.model.Ranking;
import com.lbd.gp.model.compositekey.ProvaId;
import com.lbd.gp.repository.ProvaRepository;
import com.lbd.gp.repository.RankingRepository;

@Controller
@RequestMapping("ranking")
public class RankingController {

	private RankingRepository rankingRepository;
	
	@Autowired
	private ProvaRepository provaRepository;

	@GetMapping("/{id}")
	public ModelAndView ranking(@PathVariable(name = "id") Integer id) throws ClassNotFoundException, SQLException {
		rankingRepository = new RankingDAO();
		ModelAndView mv = new ModelAndView("ranking");
		
		Prova prova = provaRepository.findByProvaIdProvaId(id);
		mv.addObject("prova", prova);
		
		try {
			List<Ranking> rankings = rankingRepository.findByFaseAndProva(false, id);
			mv.addObject("rankings", rankings);
		} catch (SQLException e) {
			e.printStackTrace();
			mv.addObject("error", e.getMessage());
		}

		return mv;
	}

}
