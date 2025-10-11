package io.github.Mahjoubech.clinicalink.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/test")
public class TestServlet extends HttpServlet {
    public void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String i = req.getParameter("text");
        System.out.println("Service method called" + i);
        resp.setContentType("text/html");
    }
 public void doGet() {
     System.out.println("Test servlet is working!");
 }
}
