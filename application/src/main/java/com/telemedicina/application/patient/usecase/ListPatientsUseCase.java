package com.telemedicina.application.patient.usecase;

import com.telemedicina.application.patient.dto.PatientResponse;
import com.telemedicina.domain.patient.port.PatientRepository;

import java.util.List;

public class ListPatientsUseCase {
    private final PatientRepository patientRepository;

    public ListPatientsUseCase(PatientRepository patientRepository) {
        this.patientRepository = patientRepository;
    }

    public List<PatientResponse> execute() {
        return patientRepository.findAll().stream()
                .map(p -> new PatientResponse(
                        p.getId(),
                        p.getUserId(),
                        p.getDocumentTypeId(),
                        p.getDocumentNumber(),
                        p.getFirstName() + " " + p.getLastName(),
                        p.getBirthDate(),
                        p.getEmail(),
                        p.getPhone(),
                        p.getAddress(),
                        p.isActive()
                ))
                .toList();
    }
}
