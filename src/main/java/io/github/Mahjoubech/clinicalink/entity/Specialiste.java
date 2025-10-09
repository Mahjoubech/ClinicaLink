package io.github.Mahjoubech.clinicalink.entity;
import io.github.Mahjoubech.clinicalink.enums.Role;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("SPECIALISTE")
public class Specialiste extends Medcen {

    private double tarif;
    private String specialite;
    public Specialiste() {}
    public Specialiste(String id , String nomComplet, String email, String tele,String password, String specialite, double tarif) {
        super(id,nomComplet, email, tele,password, Role.SPECIALISTE);
        this.specialite = specialite;
        this.tarif = tarif;
    }
    public  double getTarif() {
        return tarif;
    }
    public void setTarif(double tarif) {
        this.tarif = tarif;
    }
    public String getSpecialite() {
        return specialite;
    }
    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }

}
