# 🏛️ Arquitectura Hexagonal y Domain-Driven Design (DDD)

## 1. Desacoplamiento Multi-módulo
El proyecto se divide en 3 módulos Maven que imponen la regla de dependencia:

```
[ Domain ] <=== [ Application ] <=== [ Infrastructure ]
```

* **`domain`**:
  * POJOs puros sin anotaciones de Spring ni JPA.
  * Contiene los modelos (`User`, `Role`, `RefreshToken`, `Patient`) y las interfaces de puertos (`UserRepository`, `PatientRepository`, `TokenService`).
* **`application`**:
  * Casos de uso (`LoginUseCase`, `CreateUserUseCase`, `RegisterPatientUseCase`, etc.).
  * Commands y DTOs inmutables en Java Records.
* **`infrastructure`**:
  * Adaptadores de persistencia JPA con PostgreSQL.
  * Filtros de Spring Security 6 y JWT.
  * Controladores REST de Spring MVC.
  * Inyección explícita de dependencias a través de `BeanConfig`.
