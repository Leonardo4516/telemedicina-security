-- 1. MODELOS DE INTELIGENCIA ARTIFICIAL
CREATE TABLE IF NOT EXISTS provider_models_ai (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_provider VARCHAR(100) NOT NULL,
    base_url VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ai_models (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_model_id UUID NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    model_key VARCHAR(100) NOT NULL UNIQUE,
    input_token_price DECIMAL(12,6) NOT NULL DEFAULT 0.0,
    output_token_price DECIMAL(12,6) NOT NULL DEFAULT 0.0,
    max_tokens INTEGER NOT NULL,
    context_window INTEGER NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_ai_models_provider FOREIGN KEY (provider_model_id) REFERENCES provider_models_ai (id) ON DELETE RESTRICT
);

-- 2. CONVERSACIONES DE CHAT
CREATE TABLE IF NOT EXISTS chat_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(150),
    status_id UUID NOT NULL,
    last_message_at TIMESTAMP WITHOUT TIME ZONE,
    is_escalated BOOLEAN NOT NULL DEFAULT FALSE,
    escalation_reason TEXT,
    priority_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_chat_conversations_status FOREIGN KEY (status_id) REFERENCES conversations_statuses (id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_conversations_priority FOREIGN KEY (priority_id) REFERENCES priorities (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS chat_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL,
    participant_type_id UUID NOT NULL,
    patient_id UUID,
    professional_id UUID,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_chat_participants_conversation FOREIGN KEY (conversation_id) REFERENCES chat_conversations (id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_participants_type FOREIGN KEY (participant_type_id) REFERENCES sender_types (id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_participants_patient FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_participants_professional FOREIGN KEY (professional_id) REFERENCES professionals (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chat_conversation_ai_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL UNIQUE,
    ai_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    default_model_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_chat_ai_settings_conversation FOREIGN KEY (conversation_id) REFERENCES chat_conversations (id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_ai_settings_model FOREIGN KEY (default_model_id) REFERENCES ai_models (id) ON DELETE RESTRICT
);

-- 3. MENSAJERIA (PAYLOAD CON JSONB)
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL,
    message_type_id UUID NOT NULL,
    participant_id UUID NOT NULL,
    content TEXT NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_chat_messages_conversation FOREIGN KEY (conversation_id) REFERENCES chat_conversations (id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_messages_type FOREIGN KEY (message_type_id) REFERENCES message_types (id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_messages_participant FOREIGN KEY (participant_id) REFERENCES chat_participants (id) ON DELETE CASCADE
);

-- 4. EJECUCIONES DE IA, METRICAS Y ERRORES
CREATE TABLE IF NOT EXISTS chat_ai_runs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL,
    message_id UUID,
    model_id UUID NOT NULL,
    run_status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_chat_ai_runs_conversation FOREIGN KEY (conversation_id) REFERENCES chat_conversations (id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_ai_runs_message FOREIGN KEY (message_id) REFERENCES chat_messages (id) ON DELETE SET NULL,
    CONSTRAINT fk_chat_ai_runs_model FOREIGN KEY (model_id) REFERENCES ai_models (id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_ai_runs_status FOREIGN KEY (run_status_id) REFERENCES ai_runs_statuses (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS chat_ai_run_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ai_run_id UUID NOT NULL UNIQUE,
    prompt_tokens INTEGER NOT NULL DEFAULT 0,
    completion_tokens INTEGER NOT NULL DEFAULT 0,
    total_tokens INTEGER NOT NULL DEFAULT 0,
    cost DECIMAL(10,6) NOT NULL DEFAULT 0.0,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_ai_run_metrics_run FOREIGN KEY (ai_run_id) REFERENCES chat_ai_runs (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chat_ai_run_errors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ai_run_id UUID NOT NULL,
    error_message TEXT NOT NULL,
    error_code VARCHAR(50),
    provider_error_id VARCHAR(100),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_ai_run_errors_run FOREIGN KEY (ai_run_id) REFERENCES chat_ai_runs (id) ON DELETE CASCADE
);

-- 5. ESCALAMIENTO HUMANO
CREATE TABLE IF NOT EXISTS chat_escalations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL,
    status_id UUID NOT NULL,
    from_ai BOOLEAN NOT NULL DEFAULT TRUE,
    reason TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_chat_escalations_conversation FOREIGN KEY (conversation_id) REFERENCES chat_conversations (id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_escalations_status FOREIGN KEY (status_id) REFERENCES escalations_statuses (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS chat_escalation_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escalation_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    assigned_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_escalation_assign_escalation FOREIGN KEY (escalation_id) REFERENCES chat_escalations (id) ON DELETE CASCADE,
    CONSTRAINT fk_escalation_assign_professional FOREIGN KEY (professional_id) REFERENCES professionals (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS chat_escalation_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escalation_id UUID NOT NULL,
    status_id UUID NOT NULL,
    changed_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_escalation_history_escalation FOREIGN KEY (escalation_id) REFERENCES chat_escalations (id) ON DELETE CASCADE,
    CONSTRAINT fk_escalation_history_status FOREIGN KEY (status_id) REFERENCES escalations_statuses (id) ON DELETE RESTRICT
);
