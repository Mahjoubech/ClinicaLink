package io.github.Mahjoubech.clinicalink.service;

import io.github.Mahjoubech.clinicalink.dto.MedcenDTO;
import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.enums.Role;

import java.util.List;
import java.util.Optional;

public interface MedcenServiceInterface {
    boolean emailExiste(String email);
    boolean teleExit(String tele);
    boolean registerMedcen(MedcenDTO dto);
    boolean updateProfile(MedcenDTO dto);
    Optional<Medcen> findById(Long id);
    Optional<Medcen> findByEmail(String email);
    List<Medcen> findAll();
    boolean authenticate(String email, String password);
    boolean deleteMedcen(String email);
    List<Medcen> findByRole(Role role);
}
