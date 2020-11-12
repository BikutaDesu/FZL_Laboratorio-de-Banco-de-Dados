package com.lbd.gp.model.compositekey;

import java.io.Serializable;

public class ProvaId implements Serializable{

	private Integer id;
	private Boolean sexo;

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
	
}
