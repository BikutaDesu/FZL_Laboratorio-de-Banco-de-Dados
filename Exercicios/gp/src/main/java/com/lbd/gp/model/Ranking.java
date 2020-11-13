package com.lbd.gp.model;

public class Ranking {

	private String prova;
	private Integer idAtleta;
	private String nomeAtleta;
	private String score;
	private String pais;

	public Ranking() {

	}

	public Ranking(String prova, Integer idAtleta, String nomeAtleta, String score, String pais) {
		super();
		this.prova = prova;
		this.idAtleta = idAtleta;
		this.nomeAtleta = nomeAtleta;
		this.score = score;
		this.pais = pais;
	}

	public String getProva() {
		return prova;
	}

	public void setProva(String prova) {
		this.prova = prova;
	}

	public Integer getIdAtleta() {
		return idAtleta;
	}

	public void setIdAtleta(Integer idAtleta) {
		this.idAtleta = idAtleta;
	}

	public String getNomeAtleta() {
		return nomeAtleta;
	}

	public void setNomeAtleta(String nomeAtleta) {
		this.nomeAtleta = nomeAtleta;
	}

	public String getScore() {
		return score;
	}

	public void setScore(String score) {
		this.score = score;
	}

	public String getPais() {
		return pais;
	}

	public void setPais(String pais) {
		this.pais = pais;
	}

	@Override
	public String toString() {
		return "\nRanking [prova=" + prova + ", idAtleta=" + idAtleta + ", nomeAtleta=" + nomeAtleta + ", score=" + score
				+ ", pais=" + pais + "]";
	}

}
