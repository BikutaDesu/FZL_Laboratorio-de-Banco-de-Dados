package com.lbd.gp.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "score")
public class Score implements Serializable{
	
	@Id
	private Integer id;
	private Boolean fase;
	private String score;
	
	@ManyToOne(fetch = FetchType.LAZY)
	private Atleta atleta;
	
	@ManyToOne(fetch = FetchType.LAZY)
	private Prova prova;
	
	public Score() {
		
	}

	public Score(Integer id, Boolean fase, String score, Atleta atleta, Prova prova) {
		super();
		this.id = id;
		this.fase = fase;
		this.score = score;
		this.atleta = atleta;
		this.prova = prova;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Boolean getFase() {
		return fase;
	}

	public void setFase(Boolean fase) {
		this.fase = fase;
	}

	public String getScore() {
		return score;
	}

	public void setScore(String score) {
		this.score = score;
	}

	public Atleta getAtleta() {
		return atleta;
	}

	public void setAtleta(Atleta atleta) {
		this.atleta = atleta;
	}

	public Prova getProva() {
		return prova;
	}

	public void setProva(Prova prova) {
		this.prova = prova;
	}
	
}
