-- 1. TABLA PATIENTS CON RELACION A USERS
CREATE TABLE IF NOT EXISTS patients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE,
    document_type_id UUID NOT NULL,
    document_number VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    second_last_name VARCHAR(50),
    birth_date DATE NOT NULL,
    biological_sex_id UUID NOT NULL,
    gender_identity_id UUID,
    email VARCHAR(150),
    phone VARCHAR(30),
    address VARCHAR(200),
    city_id UUID,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    created_by UUID,
    updated_by UUID,
    CONSTRAINT fk_patients_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
    CONSTRAINT fk_patients_document_type FOREIGN KEY (document_type_id) REFERENCES document_types (id) ON DELETE RESTRICT,
    CONSTRAINT fk_patients_biological_sex FOREIGN KEY (biological_sex_id) REFERENCES genders (id) ON DELETE RESTRICT,
    CONSTRAINT fk_patients_gender_identity FOREIGN KEY (gender_identity_id) REFERENCES genders (id) ON DELETE RESTRICT,
    CONSTRAINT fk_patients_city FOREIGN KEY (city_id) REFERENCES city_municipalities (id) ON DELETE SET NULL
);

-- 2. TABLA PROFESSIONALS CON RELACION A USERS
CREATE TABLE IF NOT EXISTS professionals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE,
    document_type_id UUID NOT NULL,
    document_number VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(30),
    professional_type_id UUID NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    city_id UUID,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_professionals_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
    CONSTRAINT fk_professionals_document_type FOREIGN KEY (document_type_id) REFERENCES document_types (id) ON DELETE RESTRICT,
    CONSTRAINT fk_professionals_type FOREIGN KEY (professional_type_id) REFERENCES profession_types (id) ON DELETE RESTRICT,
    CONSTRAINT fk_professionals_city FOREIGN KEY (city_id) REFERENCES city_municipalities (id) ON DELETE SET NULL
);

-- 3. ESTUDIOS DE PROFESIONALES
CREATE TABLE IF NOT EXISTS professional_studies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    study_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    title VARCHAR(150) NOT NULL,
    university VARCHAR(150) NOT NULL,
    graduation_year INTEGER NOT NULL,
    institution_number VARCHAR(50),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_prof_studies_study FOREIGN KEY (study_id) REFERENCES studies (id) ON DELETE RESTRICT,
    CONSTRAINT fk_prof_studies_professional FOREIGN KEY (professional_id) REFERENCES professionals (id) ON DELETE CASCADE
);

-- 4. CONTACTOS Y AGENDAS
CREATE TABLE IF NOT EXISTS contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150),
    relationship_type_id UUID NOT NULL,
    city_id UUID,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_contacts_relationship FOREIGN KEY (relationship_type_id) REFERENCES relationship_types (id) ON DELETE RESTRICT,
    CONSTRAINT fk_contacts_city FOREIGN KEY (city_id) REFERENCES city_municipalities (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS patient_contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contact_id UUID NOT NULL,
    patient_id UUID NOT NULL,
    is_primary_contact BOOLEAN NOT NULL DEFAULT FALSE,
    is_emergency_contact BOOLEAN NOT NULL DEFAULT FALSE,
    relationship_type_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_patient_contacts_contact FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE,
    CONSTRAINT fk_patient_contacts_patient FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE,
    CONSTRAINT fk_patient_contacts_rel FOREIGN KEY (relationship_type_id) REFERENCES relationship_types (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS phone_contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contact_id UUID NOT NULL,
    phone VARCHAR(30) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_phone_contacts_contact FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS email_contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contact_id UUID NOT NULL,
    email VARCHAR(150) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_email_contacts_contact FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE
);

-- 5. ALERGIAS DEL PACIENTE
CREATE TABLE IF NOT EXISTS patient_allergies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL,
    allergen VARCHAR(100) NOT NULL,
    reaction TEXT,
    severity VARCHAR(50),
    recorded_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_patient_allergies_patient FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE
);
