package com.lbd.gp.model.compositekey;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class ProvaId implements Serializable{

	@Column(name = "id")
	private Integer provaId;
	
	@Column(name = "sexo")
	private Boolean sexo;
	
	

	public Integer getId() {
		return provaId;
	}

	public void setId(Integer provaId) {
		this.provaId = provaId;
	}

	public Boolean getSexo() {
		return sexo;
	}

	public void setSexo(Boolean sexo) {
		this.sexo = sexo;
	}
	
}
