package com.telemedicina.infrastructure.persistence.repository;

import com.telemedicina.infrastructure.persistence.entity.PatientJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PatientJpaRepository extends JpaRepository<PatientJpaEntity, UUID> {
    Optional<PatientJpaEntity> findByDocumentNumber(String documentNumber);
}
