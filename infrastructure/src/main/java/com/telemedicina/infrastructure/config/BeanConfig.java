package com.telemedicina.infrastructure.config;

import com.telemedicina.application.patient.usecase.ListPatientsUseCase;
import com.telemedicina.application.patient.usecase.RegisterPatientUseCase;
import com.telemedicina.application.usecase.CreateUserUseCase;
import com.telemedicina.application.usecase.GetCurrentUserUseCase;
import com.telemedicina.application.usecase.LoginUseCase;
import com.telemedicina.application.usecase.RefreshTokenUseCase;
import com.telemedicina.domain.patient.port.PatientRepository;
import com.telemedicina.domain.ports.PasswordService;
import com.telemedicina.domain.ports.RefreshTokenRepository;
import com.telemedicina.domain.ports.RoleRepository;
import com.telemedicina.domain.ports.TokenService;
import com.telemedicina.domain.ports.UserRepository;
import com.telemedicina.infrastructure.persistence.adapters.PatientRepositoryAdapter;
import com.telemedicina.infrastructure.persistence.adapters.RefreshTokenRepositoryAdapter;
import com.telemedicina.infrastructure.persistence.adapters.RoleRepositoryAdapter;
import com.telemedicina.infrastructure.persistence.adapters.UserRepositoryAdapter;
import com.telemedicina.infrastructure.persistence.repository.PatientJpaRepository;
import com.telemedicina.infrastructure.persistence.repository.RefreshTokenJpaRepository;
import com.telemedicina.infrastructure.persistence.repository.RoleJpaRepository;
import com.telemedicina.infrastructure.persistence.repository.UserJpaRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class BeanConfig {

    @Bean
    public RoleRepository roleRepository(RoleJpaRepository roleJpaRepository) {
        return new RoleRepositoryAdapter(roleJpaRepository);
    }

    @Bean
    public UserRepository userRepository(UserJpaRepository userJpaRepository, RoleJpaRepository roleJpaRepository) {
        return new UserRepositoryAdapter(userJpaRepository, roleJpaRepository);
    }

    @Bean
    public RefreshTokenRepository refreshTokenRepository(RefreshTokenJpaRepository refreshTokenJpaRepository) {
        return new RefreshTokenRepositoryAdapter(refreshTokenJpaRepository);
    }

    @Bean
    public PatientRepository patientRepository(PatientJpaRepository patientJpaRepository) {
        return new PatientRepositoryAdapter(patientJpaRepository);
    }

    @Bean
    public LoginUseCase loginUseCase(UserRepository userRepository,
                                     PasswordService passwordService,
                                     TokenService tokenService,
                                     RefreshTokenRepository refreshTokenRepository) {
        return new LoginUseCase(userRepository, passwordService, tokenService, refreshTokenRepository);
    }

    @Bean
    public CreateUserUseCase createUserUseCase(UserRepository userRepository,
                                               RoleRepository roleRepository,
                                               PasswordService passwordService) {
        return new CreateUserUseCase(userRepository, roleRepository, passwordService);
    }

    @Bean
    public RefreshTokenUseCase refreshTokenUseCase(RefreshTokenRepository refreshTokenRepository,
                                                   UserRepository userRepository,
                                                   TokenService tokenService) {
        return new RefreshTokenUseCase(refreshTokenRepository, userRepository, tokenService);
    }

    @Bean
    public GetCurrentUserUseCase getCurrentUserUseCase(UserRepository userRepository) {
        return new GetCurrentUserUseCase(userRepository);
    }

    @Bean
    public RegisterPatientUseCase registerPatientUseCase(PatientRepository patientRepository) {
        return new RegisterPatientUseCase(patientRepository);
    }

    @Bean
    public ListPatientsUseCase listPatientsUseCase(PatientRepository patientRepository) {
        return new ListPatientsUseCase(patientRepository);
    }
}
