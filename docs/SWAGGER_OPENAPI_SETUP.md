# 📖 Configuración y Uso de Swagger / OpenAPI 3

## 1. URLs de Acceso
* **Swagger UI:** [http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)
* **OpenAPI JSON Docs:** [http://localhost:8080/v3/api-docs](http://localhost:8080/v3/api-docs)

---

## 2. Configuración de Seguridad en OpenAPI
El proyecto implementa la anotación `@SecurityScheme` en `OpenApiConfig`:
```java
@SecurityScheme(
    name = "Bearer Authentication",
    type = SecuritySchemeType.HTTP,
    bearerFormat = "JWT",
    scheme = "bearer"
)
```

---

## 3. Guía de Prueba Interactiva en Swagger UI

1. Ingrese a `http://localhost:8080/swagger-ui/index.html`.
2. Vaya al grupo **Autenticación** > `POST /auth/login`.
3. Ingrese:
   ```json
   {
     "email": "admin@telemedicina.com",
     "password": "Password123!"
   }
   ```
4. Copie el valor de `accessToken` recibido.
5. Haga clic en el botón superior **Authorize** 🔓.
6. Pegue el token en el campo `Value` con el prefijo `Bearer <token>` y confirme.
7. Pruebe los endpoints protegidos del grupo **Pacientes (Protegido)** como `GET /api/v1/patients` o `POST /api/v1/patients`.
