package com.yologger.samples.testapp;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("/test1")
    String test1() {
        return "test1";
    }

    @GetMapping("/test2")
    String test2() {
        return "test2";
    }
}
