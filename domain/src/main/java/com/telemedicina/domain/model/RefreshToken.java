package com.telemedicina.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

public class RefreshToken {
    private final UUID id;
    private final UUID userId;
    private final String token;
    private final LocalDateTime expiresAt;
    private boolean revoked;

    public RefreshToken(UUID id, UUID userId, String token, LocalDateTime expiresAt, boolean revoked) {
        this.id = id;
        this.userId = userId;
        this.token = token;
        this.expiresAt = expiresAt;
        this.revoked = revoked;
    }

    public UUID getId() { return id; }
    public UUID getUserId() { return userId; }
    public String getToken() { return token; }
    public LocalDateTime getExpiresAt() { return expiresAt; }
    public boolean isRevoked() { return revoked; }

    public void revoke() {
        this.revoked = true;
    }

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }
}
