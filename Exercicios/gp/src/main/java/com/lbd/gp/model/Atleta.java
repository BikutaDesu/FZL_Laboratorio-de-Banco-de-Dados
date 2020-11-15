package com.lbd.gp.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
public class Atleta implements Serializable {

	@Id
	private Integer id;
	private String nome;
	private Boolean sexo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "coi")
	private Pais pais;

	@OneToMany(cascade = CascadeType.ALL, mappedBy = "atleta", fetch = FetchType.LAZY)
	private List<Score> scores;

	public Atleta() {

	}

	public Atleta(Integer id, String nome, Boolean sexo, Pais pais) {
		super();
		this.id = id;
		this.nome = nome;
		this.sexo = sexo;
		this.pais = pais;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public Boolean getSexo() {
		return sexo;
	}

	public void setSexo(Boolean sexo) {
		this.sexo = sexo;
	}

	public Pais getCoi() {
		return pais;
	}

	public void setCoi(Pais pais) {
		this.pais = pais;
	}

}
