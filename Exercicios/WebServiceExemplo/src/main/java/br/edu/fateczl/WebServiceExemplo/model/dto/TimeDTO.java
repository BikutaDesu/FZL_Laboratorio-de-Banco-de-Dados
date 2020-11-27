package br.edu.fateczl.WebServiceExemplo.model.dto;

import br.edu.fateczl.WebServiceExemplo.model.entity.Time;

public class TimeDTO {

	private Integer id;
	private String nome;
	private String cidade;

	public TimeDTO() {
	}

	public TimeDTO(Integer id, String nome, String cidade) {
		super();
		this.id = id;
		this.nome = nome;
		this.cidade = cidade;
	}

	public TimeDTO(Time time) {
		super();
		this.id = time.getId();
		this.nome = time.getNome();
		this.cidade = time.getCidade();
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

	public String getCidade() {
		return cidade;
	}

	public void setCidade(String cidade) {
		this.cidade = cidade;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((cidade == null) ? 0 : cidade.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + ((nome == null) ? 0 : nome.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		TimeDTO other = (TimeDTO) obj;
		if (cidade == null) {
			if (other.cidade != null)
				return false;
		} else if (!cidade.equals(other.cidade))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (nome == null) {
			if (other.nome != null)
				return false;
		} else if (!nome.equals(other.nome))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Time [id=" + id + ", nome=" + nome + ", cidade=" + cidade + "]";
	}

}
