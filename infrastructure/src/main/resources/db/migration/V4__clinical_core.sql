-- 1. CLINICAL RECORDS (HISTORIA CLINICA GLOBAL)
CREATE TABLE IF NOT EXISTS clinical_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL,
    creation_date TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    record_number VARCHAR(50) NOT NULL UNIQUE,
    status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    created_by UUID,
    CONSTRAINT fk_clinical_records_patient FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE RESTRICT,
    CONSTRAINT fk_clinical_records_status FOREIGN KEY (status_id) REFERENCES clinical_record_statuses (id) ON DELETE RESTRICT
);

-- 2. ENCOUNTERS (ENCUENTROS / CITAS CLINICAS)
CREATE TABLE IF NOT EXISTS encounters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinical_record_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    encounter_type_id UUID NOT NULL,
    started_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    ended_at TIMESTAMP WITHOUT TIME ZONE,
    reason_for_visit TEXT NOT NULL,
    current_condition TEXT,
    modality_id UUID NOT NULL,
    status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    created_by UUID,
    updated_by UUID,
    CONSTRAINT fk_encounters_record FOREIGN KEY (clinical_record_id) REFERENCES clinical_records (id) ON DELETE CASCADE,
    CONSTRAINT fk_encounters_professional FOREIGN KEY (professional_id) REFERENCES professionals (id) ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_type FOREIGN KEY (encounter_type_id) REFERENCES encounter_types (id) ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_modality FOREIGN KEY (modality_id) REFERENCES encounter_modalities (id) ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_status FOREIGN KEY (status_id) REFERENCES encounter_statuses (id) ON DELETE RESTRICT
);

-- 3. CLINICAL NOTES (NOTAS DE EVOLUCION CLINICA)
CREATE TABLE IF NOT EXISTS clinical_notes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    encounter_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    subjective TEXT,
    objective TEXT,
    assessment TEXT,
    plan TEXT,
    additional_notes TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_clinical_notes_encounter FOREIGN KEY (encounter_id) REFERENCES encounters (id) ON DELETE CASCADE,
    CONSTRAINT fk_clinical_notes_professional FOREIGN KEY (professional_id) REFERENCES professionals (id) ON DELETE RESTRICT
);

-- 4. MENTAL STATUS EXAMS (EXAMEN DEL ESTADO MENTAL)
CREATE TABLE IF NOT EXISTS mental_status_exams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    encounter_id UUID NOT NULL UNIQUE,
    appearance TEXT,
    behavior TEXT,
    attitude TEXT,
    consciousness TEXT,
    orientation TEXT,
    memory TEXT,
    attention TEXT,
    speech TEXT,
    mood TEXT,
    affect TEXT,
    thought_process TEXT,
    thought_content TEXT,
    perception TEXT,
    insight TEXT,
    judgment TEXT,
    psychomotor_activity TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    created_by UUID,
    CONSTRAINT fk_mental_exams_encounter FOREIGN KEY (encounter_id) REFERENCES encounters (id) ON DELETE CASCADE
);

-- 5. RISK ASSESSMENTS (EVALUACION DE RIESGO SUICIDA / TERCEROS)
CREATE TABLE IF NOT EXISTS risk_assessments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    encounter_id UUID NOT NULL,
    risk_level_id UUID NOT NULL,
    suicidal_ideation BOOLEAN NOT NULL DEFAULT FALSE,
    suicide_plan BOOLEAN NOT NULL DEFAULT FALSE,
    suicide_attempt_history BOOLEAN NOT NULL DEFAULT FALSE,
    self_harm BOOLEAN NOT NULL DEFAULT FALSE,
    harm_to_others BOOLEAN NOT NULL DEFAULT FALSE,
    risk_factors TEXT,
    protective_factors TEXT,
    clinical_actions TEXT,
    observations TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    assessed_by UUID,
    CONSTRAINT fk_risk_assessments_encounter FOREIGN KEY (encounter_id) REFERENCES encounters (id) ON DELETE CASCADE,
    CONSTRAINT fk_risk_assessments_level FOREIGN KEY (risk_level_id) REFERENCES risk_levels (id) ON DELETE RESTRICT
);

-- 6. TREATMENT PLANS Y GOALS
CREATE TABLE IF NOT EXISTS treatment_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    encounter_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    treatment_status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_treatment_plans_encounter FOREIGN KEY (encounter_id) REFERENCES encounters (id) ON DELETE CASCADE,
    CONSTRAINT fk_treatment_plans_professional FOREIGN KEY (professional_id) REFERENCES professionals (id) ON DELETE RESTRICT,
    CONSTRAINT fk_treatment_plans_status FOREIGN KEY (treatment_status_id) REFERENCES treatment_statuses (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS treatment_goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    treatment_plan_id UUID NOT NULL,
    description TEXT NOT NULL,
    target_date DATE,
    completed_date DATE,
    treatment_goal_status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_treatment_goals_plan FOREIGN KEY (treatment_plan_id) REFERENCES treatment_plans (id) ON DELETE CASCADE,
    CONSTRAINT fk_treatment_goals_status FOREIGN KEY (treatment_goal_status_id) REFERENCES treatment_goal_statuses (id) ON DELETE RESTRICT
);
