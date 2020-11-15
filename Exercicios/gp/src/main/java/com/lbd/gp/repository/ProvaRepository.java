package com.lbd.gp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lbd.gp.model.Prova;
import com.lbd.gp.model.compositekey.ProvaId;

@Repository
public interface ProvaRepository extends JpaRepository<Prova, ProvaId> {
	
	Prova findByProvaIdProvaId(Integer id);
	
}
