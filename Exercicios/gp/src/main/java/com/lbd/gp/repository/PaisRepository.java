package com.lbd.gp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lbd.gp.model.Pais;

@Repository
public interface PaisRepository extends JpaRepository<Pais, String> {
	
}
