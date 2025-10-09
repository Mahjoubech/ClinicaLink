package io.github.Mahjoubech.clinicalink.mapper;

import io.github.Mahjoubech.clinicalink.dto.MedcenDTO;
import io.github.Mahjoubech.clinicalink.entity.*;
import io.github.Mahjoubech.clinicalink.utils.Helper;

public class MedcenMapper {

    public static Medcen toEntity(MedcenDTO dto) {
        return switch (dto.getRole()) {
            case GENERALISTE -> new Generaliste(Helper.generateGeneralisteID(), dto.getNomComplet(), dto.getEmail(), dto.getTele(),dto.getPassword() ,150 );
            case SPECIALISTE -> new Specialiste(Helper.generateSpecialisteID(),dto.getNomComplet(), dto.getEmail(), dto.getTele(),dto.getPassword(), dto.getSpecialite(), dto.getTarif());
            default -> new Infirmer(Helper.generateInfirmierID(),dto.getNomComplet(), dto.getEmail(), dto.getTele(),dto.getPassword());
        };
    }
}
