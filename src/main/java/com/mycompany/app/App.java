package com.mycompany.app;

public class App {
    public String greet(String name) {
        return "Hello, " + name;
    }

    public String letssee(String name) {
        return "Hello Piyush & , " + name;
    }

    public static void main(String[] args) {
        App app = new App();
        System.out.println(app.greet("World"));
    }
}

