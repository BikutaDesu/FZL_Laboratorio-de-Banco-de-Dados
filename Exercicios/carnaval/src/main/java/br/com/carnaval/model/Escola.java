package br.com.carnaval.model;

public class Escola {

	private Long id;
	private String nome;
	private Float notaTotal;
	
	public Escola() {

	}
	
	public Escola(Long id, String nome) {
		super();
		this.id = id;
		this.nome = nome;
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
	
	public Float getNotaTotal() {
		return notaTotal;
	}

	public void setNotaTotal(Float notaTotal) {
		this.notaTotal = notaTotal;
	}

	@Override
	public String toString() {
		return "Escola [id=" + id + ", nome=" + nome + ", notaTotal=" + notaTotal + "]";
	}

	
	
	
	
	
}
