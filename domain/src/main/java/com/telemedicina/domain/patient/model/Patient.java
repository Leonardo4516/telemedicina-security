package com.telemedicina.domain.patient.model;

import java.time.LocalDate;
import java.util.UUID;

public class Patient {
    private final UUID id;
    private final UUID userId;
    private final UUID documentTypeId;
    private final String documentNumber;
    private String firstName;
    private String middleName;
    private String lastName;
    private String secondLastName;
    private LocalDate birthDate;
    private UUID biologicalSexId;
    private String email;
    private String phone;
    private String address;
    private boolean active;

    public Patient(UUID id, UUID userId, UUID documentTypeId, String documentNumber,
                   String firstName, String middleName, String lastName, String secondLastName,
                   LocalDate birthDate, UUID biologicalSexId, String email, String phone,
                   String address, boolean active) {
        this.id = id;
        this.userId = userId;
        this.documentTypeId = documentTypeId;
        this.documentNumber = documentNumber;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.secondLastName = secondLastName;
        this.birthDate = birthDate;
        this.biologicalSexId = biologicalSexId;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.active = active;
    }

    public UUID getId() { return id; }
    public UUID getUserId() { return userId; }
    public UUID getDocumentTypeId() { return documentTypeId; }
    public String getDocumentNumber() { return documentNumber; }
    public String getFirstName() { return firstName; }
    public String getMiddleName() { return middleName; }
    public String getLastName() { return lastName; }
    public String getSecondLastName() { return secondLastName; }
    public LocalDate getBirthDate() { return birthDate; }
    public UUID getBiologicalSexId() { return biologicalSexId; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public boolean isActive() { return active; }
}
