package br.com.carnaval.model;

import java.util.List;

public class Quesito {

	private Long id;
	private String nome;
	private List<Float> notas;
	private Float maiorNota;
	private Float menorNota;
	private Float notaTotal;
	
	public Quesito(Long id, String nome) {
		super();
		this.id = id;
		this.nome = nome;
	}
	
	public Quesito() {
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public List<Float> getNotas() {
		return notas;
	}

	public void setNotas(List<Float> notas) {
		this.notas = notas;
	}

	public Float getMaiorNota() {
		return maiorNota;
	}

	public void setMaiorNota(Float maiorNota) {
		this.maiorNota = maiorNota;
	}

	public Float getMenorNota() {
		return menorNota;
	}

	public void setMenorNota(Float menorNota) {
		this.menorNota = menorNota;
	}

	public Float getNotaTotal() {
		return notaTotal;
	}

	public void setNotaTotal(Float notaTotal) {
		this.notaTotal = notaTotal;
	}
	
}
