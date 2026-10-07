-- Inserción de Roles del Sistema
INSERT INTO roles (id, name, authority) VALUES
    ('550e8400-e29b-41d4-a716-446655440001', 'USER', 'ROLE_USER'),
    ('550e8400-e29b-41d4-a716-446655440002', 'ADMIN', 'ROLE_ADMIN'),
    ('550e8400-e29b-41d4-a716-446655440003', 'PROFESSIONAL', 'ROLE_PROFESSIONAL'),
    ('550e8400-e29b-41d4-a716-446655440004', 'PATIENT', 'ROLE_PATIENT')
ON CONFLICT (id) DO NOTHING;

-- Usuario Administrador Inicial (password: Password123! hasheado con BCrypt)
INSERT INTO users (id, email, password, status) VALUES
    ('660e8400-e29b-41d4-a716-446655440001', 'admin@telemedicina.com', '$2a$10$OYnO1hmc6B3EdL6IDAycb.tx19772lPABDop52.ed8o8AUEmc0IXm', 'ACTIVE')
ON CONFLICT (email) DO NOTHING;

-- Asignación de rol ADMIN al usuario inicial
INSERT INTO user_roles (user_id, role_id) VALUES
    ('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002')
ON CONFLICT DO NOTHING;

-- Catálogos Semilla
INSERT INTO document_types (id, code, name, active) VALUES
    ('a0000000-0000-0000-0000-000000000001', 'CC', 'Cédula de Ciudadanía', true),
    ('a0000000-0000-0000-0000-000000000002', 'TI', 'Tarjeta de Identidad', true),
    ('a0000000-0000-0000-0000-000000000003', 'PAS', 'Pasaporte', true)
ON CONFLICT (code) DO NOTHING;

INSERT INTO genders (id, code, description) VALUES
    ('b0000000-0000-0000-0000-000000000001', 'M', 'Masculino'),
    ('b0000000-0000-0000-0000-000000000002', 'F', 'Femenino'),
    ('b0000000-0000-0000-0000-000000000003', 'NB', 'No Binario')
ON CONFLICT (code) DO NOTHING;

INSERT INTO countries (id, name_country, code_country, is_active, telephone_prefix) VALUES
    ('c0000000-0000-0000-0000-000000000001', 'Colombia', 'COL', true, '+57')
ON CONFLICT (code_country) DO NOTHING;
