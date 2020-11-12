package com.lbd.gp.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "atleta")
public class Atleta implements Serializable{

	@Id
	private Integer Id;
	private String nome;
	private Boolean sexo;

	@ManyToOne(fetch = FetchType.LAZY)
	private Pais coi;
	
	@OneToMany(cascade = CascadeType.ALL, mappedBy = "atleta", fetch = FetchType.LAZY)
	private List<Score> scores;
	
	public Atleta() {

	}

	public Atleta(Integer id, String nome, Boolean sexo, Pais coi) {
		super();
		Id = id;
		this.nome = nome;
		this.sexo = sexo;
		this.coi = coi;
	}

	public Integer getId() {
		return Id;
	}

	public void setId(Integer id) {
		Id = id;
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
		return coi;
	}

	public void setCoi(Pais coi) {
		this.coi = coi;
	}

}
