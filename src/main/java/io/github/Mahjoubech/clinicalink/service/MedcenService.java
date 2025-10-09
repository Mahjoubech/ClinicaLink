package io.github.Mahjoubech.clinicalink.service;

import io.github.Mahjoubech.clinicalink.dao.MedcenDAO;
import io.github.Mahjoubech.clinicalink.dto.MedcenDTO;
import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.enums.Role;
import io.github.Mahjoubech.clinicalink.mapper.MedcenMapper;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class MedcenService implements MedcenServiceInterface {

    private final MedcenDAO medcenDAO = new MedcenDAO();

    @Override
    public boolean emailExiste(String email) {
        return medcenDAO.findAll().stream()
                .anyMatch(medcen -> medcen.getEmail().equals(email));
    }

    @Override
    public boolean teleExit(String tele) {
        return medcenDAO.findAll().stream()
                .anyMatch(medcen -> tele != null && tele.equals(medcen.getTele()));
    }

    @Override
    public boolean registerMedcen(MedcenDTO dto) {
        try {
            // Check if email already exists using Stream API
            boolean emailExists = medcenDAO.findAll().stream()
                    .anyMatch(medcen -> medcen.getEmail().equals(dto.getEmail()));

            if (emailExists) {
                return false;
            }

            // Check if telephone already exists using Stream API
            boolean teleExists = medcenDAO.findAll().stream()
                    .anyMatch(medcen -> dto.getTele() != null &&
                            dto.getTele().equals(medcen.getTele()));

            if (teleExists) {
                return false;
            }

            Medcen entity = MedcenMapper.toEntity(dto);
            medcenDAO.save(entity);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateProfile(MedcenDTO dto) {
        try {
            // Find by email using Stream API
            Optional<Medcen> existingOpt = medcenDAO.findAll().stream()
                    .filter(medcen -> medcen.getEmail().equals(dto.getEmail()))
                    .findFirst();

            if (existingOpt.isPresent()) {
                Medcen existing = existingOpt.get();

                // Update fields
                existing.setNomComplet(dto.getNomComplet());
                existing.setTele(dto.getTele());

                // Only update password if provided and not empty
                if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
                    existing.setPassword(dto.getPassword());
                }

                medcenDAO.update(existing);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Optional<Medcen> findByEmail(String email) {
        return medcenDAO.findAll().stream()
                .filter(medcen -> medcen.getEmail().equals(email))
                .findFirst();
    }

    @Override
    public Optional<Medcen> findById(Long id) {
        return medcenDAO.findAll().stream()
                .filter(medcen -> medcen.getId().equals(id))
                .findFirst();
    }

    @Override
    public List<Medcen> findAll() {
        return medcenDAO.findAll();
    }

    @Override
    public List<Medcen> findByRole(Role role) {
        return medcenDAO.findAll().stream()
                .filter(medcen -> medcen.getRole() == role)
                .collect(Collectors.toList());
    }

    @Override
    public boolean deleteMedcen(String email) {
        try {
            Optional<Medcen> medcenOpt = medcenDAO.findAll().stream()
                    .filter(medcen -> medcen.getEmail().equals(email))
                    .findFirst();

            if (medcenOpt.isPresent()) {
                medcenDAO.delete(medcenOpt.get());
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean authenticate(String email, String password) {
        try {
            // Find by email using Stream API
            Optional<Medcen> medcenOpt = medcenDAO.findAll().stream()
                    .filter(medcen -> medcen.getEmail().equals(email))
                    .findFirst();

            if (medcenOpt.isPresent()) {
                Medcen medcen = medcenOpt.get();
                // Simple password check (in real app, use BCrypt.checkpw())
                return medcen.getPassword().equals(password);
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Medcen> searchByName(String name) {
        return medcenDAO.findAll().stream()
                .filter(medcen -> medcen.getNomComplet() != null &&
                        medcen.getNomComplet().toLowerCase().contains(name.toLowerCase()))
                .collect(Collectors.toList());
    }

    public List<Medcen> sortByName() {
        return medcenDAO.findAll().stream()
                .sorted((m1, m2) -> m1.getNomComplet().compareToIgnoreCase(m2.getNomComplet()))
                .collect(Collectors.toList());
    }

    public List<Medcen> sortByRole() {
        return medcenDAO.findAll().stream()
                .sorted((m1, m2) -> m1.getRole().compareTo(m2.getRole()))
                .collect(Collectors.toList());
    }

    public long countByRole(Role role) {
        return medcenDAO.findAll().stream()
                .filter(medcen -> medcen.getRole() == role)
                .count();
    }

    public List<String> getAllEmails() {
        return medcenDAO.findAll().stream()
                .map(Medcen::getEmail)
                .collect(Collectors.toList());
    }

    public List<Medcen> getUsersWithPhone() {
        return medcenDAO.findAll().stream()
                .filter(medcen -> medcen.getTele() != null && !medcen.getTele().trim().isEmpty())
                .collect(Collectors.toList());
    }
}