package br.edu.fateczl.WebServiceExemplo.model.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedNativeQuery;
import javax.persistence.Table;

@Entity
@Table(name = "Jogadores")
@NamedNativeQuery(name = "Jogador.findJogadoresDataConv", query = "SELECT j.id as id_jogador, j.nome, j.sexo, j.altura, "
		+ "CONVERT(CHAR(10), j.dt_nasc, 103) AS dt_nasc, " + "j.id_time as fk_id_time, t.id as id_time, t.nome, "
		+ "t.cidade FROM jogadores " + "INNER JOIN times " + "ON j.id_time = t.id", resultClass = Jogador.class)
@NamedNativeQuery(name = "Jogador.findJogadorDataConv", query = "SELECT j.id as id_jogador, j.nome, j.sexo, j.altura, "
		+ "CONVERT(CHAR(10), j.dt_nasc, 103) AS dt_nasc, " + "j.id_time as fk_id_time, t.id as id_time, t.nome, "
		+ "t.cidade FROM jogadores " + "INNER JOIN times " + "ON j.id_time = t.id " + "WHERE j.id = ?1", resultClass = Jogador.class)
public class Jogador {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column
	private Integer id;

	@Column
	private String nome;

	@Column
	private String sexo;

	@Column
	private Float altura;

	@Column(name = "dt_nasc")
	private String dataNasc;

	@ManyToOne(targetEntity = Time.class)
	@JoinColumn(name = "id_time")
	private Time time;

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

	public String getSexo() {
		return sexo;
	}

	public void setSexo(String sexo) {
		this.sexo = sexo;
	}

	public Float getAltura() {
		return altura;
	}

	public void setAltura(Float altura) {
		this.altura = altura;
	}

	public String getDataNasc() {
		return dataNasc;
	}

	public void setDataNasc(String dataNasc) {
		this.dataNasc = dataNasc;
	}

	public Time getTime() {
		return time;
	}

	public void setTime(Time time) {
		this.time = time;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((altura == null) ? 0 : altura.hashCode());
		result = prime * result + ((dataNasc == null) ? 0 : dataNasc.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + ((nome == null) ? 0 : nome.hashCode());
		result = prime * result + ((sexo == null) ? 0 : sexo.hashCode());
		result = prime * result + ((time == null) ? 0 : time.hashCode());
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
		Jogador other = (Jogador) obj;
		if (altura == null) {
			if (other.altura != null)
				return false;
		} else if (!altura.equals(other.altura))
			return false;
		if (dataNasc == null) {
			if (other.dataNasc != null)
				return false;
		} else if (!dataNasc.equals(other.dataNasc))
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
		if (sexo == null) {
			if (other.sexo != null)
				return false;
		} else if (!sexo.equals(other.sexo))
			return false;
		if (time == null) {
			if (other.time != null)
				return false;
		} else if (!time.equals(other.time))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Jogador [id=" + id + ", nome=" + nome + ", sexo=" + sexo + ", altura=" + altura + ", dataNasc="
				+ dataNasc + ", times=" + time + "]";
	}
	
}
