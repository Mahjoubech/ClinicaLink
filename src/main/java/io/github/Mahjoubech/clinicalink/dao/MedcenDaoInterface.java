package io.github.Mahjoubech.clinicalink.dao;

import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.enums.Role;
import java.util.List;
import java.util.Optional;

public interface MedcenDaoInterface {
    void save(Medcen med);
    void update(Medcen med);
    void delete(Medcen med);
    Optional<Medcen> findById(Long id);
    Optional<Medcen> findByEmail(String email);
    List<Medcen> findAll();
    List<Medcen> findByRole(Role role);
    boolean emailExists(String email);
}