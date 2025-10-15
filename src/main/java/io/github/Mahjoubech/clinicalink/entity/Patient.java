//package io.github.Mahjoubech.clinicalink.entity;
//
//import jakarta.persistence.*;
//
//@Entity
//@Table(name = "patient")
//
//public class Patient {
//    @Id
//    @Column(length = 50)
//    protected String id ;
//    protected String nomComplet;
//    @Column(unique = true)
//    protected String email;
//    protected String tele;
//    protected String adresse;
//
//    public Patient() {
//    }
//    public Patient(String id , String nomComplet, String email, String tele,String adresse) {
//        this.id = id;
//        this.nomComplet = nomComplet;
//        this.email = email;
//        this.tele = tele;
//        this.adresse = adresse;
//    }
//
//    public String getId() {
//        return id;
//    }
//
//    public void setId(Long id) {
//        this.id = id;
//    }
//
//    public String getId() {
//        return id;
//    }
//    public void setId(String id) {
//        this.id = id;
//    }
//    public String getNomComplet() {
//        return nomComplet;
//    }
//    public void setNomComplet(String nomComplet) {
//        this.nomComplet = nomComplet;
//    }
//    public String getEmail() {
//        return email;
//    }
//    public void setEmail(String email) {
//        this.email = email;
//    }
//    public String getTele() {
//        return tele;
//    }
//    public void setTele(String tele) {
//        this.tele = tele;
//    }
//    public String getAdresse() {
//        return adresse;
//    }
//    public void setAdresse(String adresse) {
//        this.adresse = adresse;
//    }
//}
