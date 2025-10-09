package io.github.Mahjoubech.clinicalink.entity;

import io.github.Mahjoubech.clinicalink.enums.Role;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("INFIRMER")
public  class Infirmer extends Medcen{
    public Infirmer() {}
 public  Infirmer(String id ,String nomComplet, String email, String tele,String password){
     super(id,nomComplet,email,tele,password,Role.INFIRMER);
 }
}
