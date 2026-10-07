package com.telemedicina.application.usecase;

import com.telemedicina.application.dto.LoginResponse;
import com.telemedicina.application.dto.RefreshTokenRequest;
import com.telemedicina.domain.exceptions.InvalidCredentialsException;
import com.telemedicina.domain.model.RefreshToken;
import com.telemedicina.domain.model.User;
import com.telemedicina.domain.ports.RefreshTokenRepository;
import com.telemedicina.domain.ports.TokenService;
import com.telemedicina.domain.ports.UserRepository;

import java.util.UUID;

public class RefreshTokenUseCase {
    private final RefreshTokenRepository refreshTokenRepository;
    private final UserRepository userRepository;
    private final TokenService tokenService;

    public RefreshTokenUseCase(RefreshTokenRepository refreshTokenRepository,
                               UserRepository userRepository,
                               TokenService tokenService) {
        this.refreshTokenRepository = refreshTokenRepository;
        this.userRepository = userRepository;
        this.tokenService = tokenService;
    }

    public LoginResponse execute(RefreshTokenRequest request) {
        RefreshToken token = refreshTokenRepository.findByToken(request.refreshToken())
                .orElseThrow(() -> new InvalidCredentialsException("Refresh token inválido"));

        if (token.isRevoked() || token.isExpired()) {
            throw new InvalidCredentialsException("Refresh token expirado o revocado");
        }

        User user = userRepository.findById(token.getUserId())
                .orElseThrow(() -> new InvalidCredentialsException("Usuario no encontrado"));

        String newAccessToken = tokenService.generateAccessToken(user);
        return new LoginResponse(newAccessToken, token.getToken(), "Bearer", 900);
    }
}
