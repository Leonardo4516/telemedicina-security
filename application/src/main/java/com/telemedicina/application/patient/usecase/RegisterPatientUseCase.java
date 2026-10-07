package com.telemedicina.application.patient.usecase;

import com.telemedicina.application.patient.command.RegisterPatientCommand;
import com.telemedicina.application.patient.dto.PatientResponse;
import com.telemedicina.domain.patient.model.Patient;
import com.telemedicina.domain.patient.port.PatientRepository;

import java.util.UUID;

public class RegisterPatientUseCase {
    private final PatientRepository patientRepository;

    public RegisterPatientUseCase(PatientRepository patientRepository) {
        this.patientRepository = patientRepository;
    }

    public PatientResponse execute(RegisterPatientCommand command) {
        UUID newId = UUID.randomUUID();
        Patient patient = new Patient(
                newId,
                command.userId(),
                command.documentTypeId(),
                command.documentNumber(),
                command.firstName(),
                command.middleName(),
                command.lastName(),
                command.secondLastName(),
                command.birthDate(),
                command.biologicalSexId(),
                command.email(),
                command.phone(),
                command.address(),
                true
        );

        Patient saved = patientRepository.save(patient);
        String fullName = saved.getFirstName() + " " + saved.getLastName();

        return new PatientResponse(
                saved.getId(),
                saved.getUserId(),
                saved.getDocumentTypeId(),
                saved.getDocumentNumber(),
                fullName,
                saved.getBirthDate(),
                saved.getEmail(),
                saved.getPhone(),
                saved.getAddress(),
                saved.isActive()
        );
    }
}
