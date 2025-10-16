package io.github.Mahjoubech.clinicalink.entity;

import io.github.Mahjoubech.clinicalink.enums.Role;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@DiscriminatorValue("INFIRMER")
public  class Infirmer extends Medcen{
    public Infirmer() {}
 public  Infirmer(String id ,String nomComplet, String email, String tele,String password){
     super(id,nomComplet,email,tele,password,Role.INFIRMER);
 }
}
