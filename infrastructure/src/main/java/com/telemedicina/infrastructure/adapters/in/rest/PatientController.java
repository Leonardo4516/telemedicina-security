package com.telemedicina.infrastructure.adapters.in.rest;

import com.telemedicina.application.patient.command.RegisterPatientCommand;
import com.telemedicina.application.patient.dto.PatientResponse;
import com.telemedicina.application.patient.usecase.ListPatientsUseCase;
import com.telemedicina.application.patient.usecase.RegisterPatientUseCase;
import com.telemedicina.infrastructure.adapters.in.rest.dtos.CreatePatientRequest;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/patients")
@Tag(name = "Pacientes (Protegido)", description = "Gestión clínica de pacientes - Requiere JWT Bearer")
@SecurityRequirement(name = "Bearer Authentication")
@CrossOrigin(origins = "*")
public class PatientController {

    private final RegisterPatientUseCase registerPatientUseCase;
    private final ListPatientsUseCase listPatientsUseCase;

    public PatientController(RegisterPatientUseCase registerPatientUseCase, ListPatientsUseCase listPatientsUseCase) {
        this.registerPatientUseCase = registerPatientUseCase;
        this.listPatientsUseCase = listPatientsUseCase;
    }

    @PostMapping
    @Operation(summary = "Registrar nuevo paciente", description = "Crea un registro clínico de paciente")
    public ResponseEntity<PatientResponse> createPatient(@Valid @RequestBody CreatePatientRequest request) {
        RegisterPatientCommand command = new RegisterPatientCommand(
                request.userId(),
                request.documentTypeId(),
                request.documentNumber(),
                request.firstName(),
                request.middleName(),
                request.lastName(),
                request.secondLastName(),
                request.birthDate(),
                request.biologicalSexId(),
                request.email(),
                request.phone(),
                request.address()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(registerPatientUseCase.execute(command));
    }

    @GetMapping
    @Operation(summary = "Listar pacientes", description = "Consulta todos los pacientes registrados")
    public ResponseEntity<List<PatientResponse>> listPatients() {
        return ResponseEntity.ok(listPatientsUseCase.execute());
    }
}
