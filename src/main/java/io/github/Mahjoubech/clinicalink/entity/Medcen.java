package io.github.Mahjoubech.clinicalink.entity;

import io.github.Mahjoubech.clinicalink.enums.Role;
import jakarta.persistence.*;

@Entity
@Table(name = "medcen")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public abstract class Medcen {
    @Id
    @Column(length = 50)
    protected String id ;
    protected String nomComplet;
    protected String email;
    protected String tele;
    protected String password;
    @Enumerated(EnumType.STRING)
    protected Role role;

    public Medcen() {
    }
    public Medcen(String id , String nomComplet, String email, String tele,String password, Role role) {
        this.id = id;
        this.nomComplet = nomComplet;
        this.email = email;
        this.tele = tele;
        this.password = password;
        this.role = role;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNomComplet() {
        return nomComplet;
    }

    public void setNomComplet(String nomComplet) {
        this.nomComplet = nomComplet;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTele() {
        return tele;
    }

    public void setTele(String tele) {
        this.tele = tele;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
    @Override
    public String toString() {
        return "Medcen{" +
                "id=" + id +
                ", nomComplet='" + nomComplet + '\'' +
                ", email='" + email + '\'' +
                ", tele='" + tele + '\'' +
                ", role=" + role +
                '}';
    }
}