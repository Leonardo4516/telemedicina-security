package com.telemedicina.infrastructure.persistence.adapters;

import com.telemedicina.domain.model.RefreshToken;
import com.telemedicina.domain.ports.RefreshTokenRepository;
import com.telemedicina.infrastructure.persistence.entity.RefreshTokenEntity;
import com.telemedicina.infrastructure.persistence.repository.RefreshTokenJpaRepository;

import java.util.Optional;
import java.util.UUID;

public class RefreshTokenRepositoryAdapter implements RefreshTokenRepository {
    private final RefreshTokenJpaRepository jpaRepository;

    public RefreshTokenRepositoryAdapter(RefreshTokenJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public RefreshToken save(RefreshToken refreshToken) {
        RefreshTokenEntity entity = new RefreshTokenEntity(
                refreshToken.getId(),
                refreshToken.getUserId(),
                refreshToken.getToken(),
                refreshToken.getExpiresAt(),
                refreshToken.isRevoked()
        );
        RefreshTokenEntity saved = jpaRepository.save(entity);
        return new RefreshToken(
                saved.getId(),
                saved.getUserId(),
                saved.getToken(),
                saved.getExpiresAt(),
                saved.isRevoked()
        );
    }

    @Override
    public Optional<RefreshToken> findByToken(String token) {
        return jpaRepository.findByToken(token)
                .map(e -> new RefreshToken(e.getId(), e.getUserId(), e.getToken(), e.getExpiresAt(), e.isRevoked()));
    }

    @Override
    public void revokeByUserId(UUID userId) {
        jpaRepository.deleteByUserId(userId);
    }
}
