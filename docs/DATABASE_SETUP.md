# 🗄️ Configuración de Base de Datos y Migraciones Flyway

## 1. Información General
* **Motor:** PostgreSQL (Versión 16+ / 18)
* **Base de datos:** `telemedicina_security_db`
* **Host:** `localhost`
* **Puerto:** `5432`
* **Esquema:** `public`
* **Gestor de Migraciones:** Flyway Community Edition

---

## 2. Creación de la Base de Datos
```bash
psql -U postgres -h localhost -c "CREATE DATABASE telemedicina_security_db;"
```

---

## 3. Plan y Mapeo de Migraciones Flyway (`db/migration/`)

Las tablas del diagrama ERD y la seguridad se estructuran en 6 scripts cronológicos:

| Script | Descripción | Tablas / Objetos Creados |
| :--- | :--- | :--- |
| **`V1__catalogs_and_geography.sql`** | Extensiones, Geografía y Catálogos Generales | `uuid-ossp`, `countries`, `state_regions`, `city_municipalities`, `document_types`, `genders`, `relationship_types`, `profession_types`, `studies`, `clinical_record_statuses`, `encounter_types`, `encounter_modalities`, `encounter_statuses`, `risk_levels`, `treatment_statuses`, `treatment_goal_statuses`, `medication_routes`, `assessment_types`, `consent_types`, `diagnostic_systems`, `conversations_statuses`, `priorities`, `sender_types`, `message_types`, `escalations_statuses`, `ai_runs_statuses`. |
| **`V2__security_tables.sql`** | Módulo de Autenticación y Autorización | `roles`, `users`, `user_roles`, `refresh_tokens`. |
| **`V3__identity_and_actors.sql`** | Actores Clínicos Vinculados a Seguridad | `patients` (con `user_id`), `professionals` (con `user_id`), `professional_studies`, `contacts`, `patient_contacts`, `phone_contacts`, `email_contacts`, `patient_allergies`. |
| **`V4__clinical_core.sql`** | Core Clínico, Citas y Evaluaciones | `clinical_records`, `encounters`, `clinical_notes`, `mental_status_exams`, `risk_assessments`, `treatment_plans`, `treatment_goals`. |
| **`V5__chat_and_ai_system.sql`** | Mensajería, IA y Escalamiento | `provider_models_ai`, `ai_models`, `chat_conversations`, `chat_participants`, `chat_conversation_ai_settings`, `chat_messages` (tipo JSONB), `chat_ai_runs`, `chat_ai_run_metrics`, `chat_ai_run_errors`, `chat_escalations`, `chat_escalation_assignments`, `chat_escalation_status_history`. |
| **`V6__seed_data.sql`** | Carga de Datos Semilla | Roles (`USER`, `ADMIN`, `PROFESSIONAL`, `PATIENT`), Usuario inicial `admin@telemedicina.com`, tipos de documento, géneros y país. |

---

## 4. Conexión en DBeaver
* **Host:** `localhost`
* **Puerto:** `5432`
* **Database:** `telemedicina_security_db`
* **Username:** `postgres`
* **Password:** `123456`
