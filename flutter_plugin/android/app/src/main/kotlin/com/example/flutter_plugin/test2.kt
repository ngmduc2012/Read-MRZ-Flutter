package com.example.flutter_plugin


object test2 {
    var text = "12345678"
    var year = 1990
    @JvmStatic
    fun main(args: Array<String>) {
        text = text.substring(5)
        year % 100
        print(year % 100)
    }
}

