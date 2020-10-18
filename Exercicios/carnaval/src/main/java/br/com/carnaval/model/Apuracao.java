package br.com.carnaval.model;

import java.util.List;

public class Apuracao {

	private Escola escola;
	private List<Quesito> quesitos;
	
	public Apuracao(Escola escola, List<Quesito> quesitos) {
		super();
		this.escola = escola;
		this.quesitos = quesitos;
	}
	
	public Apuracao() {
	}

	public Escola getEscola() {
		return escola;
	}

	public void setEscola(Escola escola) {
		this.escola = escola;
	}

	public List<Quesito> getQuesitos() {
		return quesitos;
	}

	public void setQuesitos(List<Quesito> quesitos) {
		this.quesitos = quesitos;
	}
	
}
