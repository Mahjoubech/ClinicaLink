package io.github.Mahjoubech.clinicalink.entity;

import io.github.Mahjoubech.clinicalink.enums.Role;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("GENERALISTE")
public class Generaliste extends Medcen{
    private  double tarif ;
    public Generaliste(){}
    public Generaliste(String id ,String nomComplet, String email, String tele ,String password, double tarif ) {
        super(id,nomComplet, email, tele,password, Role.GENERALISTE);
        this.tarif = tarif ;
    }
    public  double getTarif() {
        return tarif;
    }
    public void setTarif(double tarif) {
        this.tarif = tarif;
    }
}

