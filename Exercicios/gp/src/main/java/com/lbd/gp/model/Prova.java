package com.lbd.gp.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.lbd.gp.model.compositekey.ProvaId;

@Entity
@Table(name = "prova")
public class Prova implements Serializable {

	@EmbeddedId
	private ProvaId provaId;

	private String nome;
	private Boolean tipo;
	@Column(name = "record_m")
	private String recordM;
	@Column(name = "record_e")
	private String recordE;
	private Integer ouro;
	private Integer prata;
	private Integer bronze;

	@OneToMany(cascade = CascadeType.ALL, mappedBy = "prova", fetch = FetchType.LAZY)
	private List<Score> scores;

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

	public ProvaId getProvaId() {
		return provaId;
	}

	public void setProvaId(ProvaId provaId) {
		this.provaId = provaId;
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
