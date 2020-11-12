package com.lbd.gp.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

import com.lbd.gp.model.compositekey.ProvaId;

@Entity
@IdClass(ProvaId.class)
@Table(name = "prova")
public class Prova implements Serializable{
	
	@Id
	private Integer id;
	@Id
	private Boolean sexo;

	private String nome;
	private Boolean tipo;
	@Column(name = "record_m")
	private String recordM;
	@Column(name = "record_e")
	private String recordE;
	private Integer ouro;
	private Integer prata;
	private Integer bronze;

	public Prova() {

	}
	
	public Prova(Integer id, Boolean sexo, String nome, Boolean tipo, String recordM, String recordE, Integer ouro,
			Integer prata, Integer bronze) {
		super();
		this.nome = nome;
		this.tipo = tipo;
		this.recordM = recordM;
		this.recordE = recordE;
		this.ouro = ouro;
		this.prata = prata;
		this.bronze = bronze;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Boolean getSexo() {
		return sexo;
	}

	public void setSexo(Boolean sexo) {
		this.sexo = sexo;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public Boolean getTipo() {
		return tipo;
	}

	public void setTipo(Boolean tipo) {
		this.tipo = tipo;
	}

	public String getRecordM() {
		return recordM;
	}

	public void setRecordM(String recordM) {
		this.recordM = recordM;
	}

	public String getRecordE() {
		return recordE;
	}

	public void setRecordE(String recordE) {
		this.recordE = recordE;
	}

	public Integer getOuro() {
		return ouro;
	}

	public void setOuro(Integer ouro) {
		this.ouro = ouro;
	}

	public Integer getPrata() {
		return prata;
	}

	public void setPrata(Integer prata) {
		this.prata = prata;
	}

	public Integer getBronze() {
		return bronze;
	}

	public void setBronze(Integer bronze) {
		this.bronze = bronze;
	}

}
