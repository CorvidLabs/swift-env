import Testing
import Foundation
@testable import Env

@Suite("Env Typed Getters")
struct EnvTypedTests {
    // MARK: - Int

    @Test("Int parsing")
    func intParsing() {
        let env = Env(["PORT": "8080", "INVALID": "abc"])
        #expect(env.int("PORT") == 8080)
        #expect(env.int("INVALID") == nil)
        #expect(env.int("MISSING") == nil)
    }

    @Test("Int with default")
    func intDefault() {
        let env = Env(["PORT": "8080"])
        #expect(env.int("PORT", default: 3000) == 8080)
        #expect(env.int("MISSING", default: 3000) == 3000)
    }

    @Test("Int negative")
    func intNegative() {
        let env = Env(["NUM": "-42"])
        #expect(env.int("NUM") == -42)
    }

    // MARK: - Double

    @Test("Double parsing")
    func doubleParsing() {
        let env = Env(["RATE": "3.14", "INVALID": "abc"])
        #expect(env.double("RATE") == 3.14)
        #expect(env.double("INVALID") == nil)
        #expect(env.double("MISSING") == nil)
    }

    @Test("Double with default")
    func doubleDefault() {
        let env = Env(["RATE": "3.14"])
        #expect(env.double("RATE", default: 1.0) == 3.14)
        #expect(env.double("MISSING", default: 1.0) == 1.0)
    }

    // MARK: - Bool

    @Test("Bool true values")
    func boolTrue() {
        for value in ["true", "TRUE", "True", "1", "yes", "YES", "on", "ON"] {
            let env = Env(["FLAG": value])
            #expect(env.bool("FLAG") == true, "Expected '\(value)' to be true")
        }
    }

    @Test("Bool false values")
    func boolFalse() {
        for value in ["false", "FALSE", "False", "0", "no", "NO", "off", "OFF"] {
            let env = Env(["FLAG": value])
            #expect(env.bool("FLAG") == false, "Expected '\(value)' to be false")
        }
    }

    @Test("Bool invalid")
    func boolInvalid() {
        let env = Env(["FLAG": "maybe"])
        #expect(env.bool("FLAG") == nil)
    }

    @Test("Bool with default")
    func boolDefault() {
        let env = Env(["FLAG": "true"])
        #expect(env.bool("FLAG", default: false) == true)
        #expect(env.bool("MISSING", default: false) == false)
    }

    // MARK: - URL

    @Test("URL parsing")
    func urlParsing() {
        let env = Env(["API": "https://api.example.com"])
        #expect(env.url("API")?.absoluteString == "https://api.example.com")
        #expect(env.url("MISSING") == nil)
    }

    @Test("URL with default")
    func urlDefault() {
        let defaultURL = URL(string: "https://default.com")!
        let env = Env(["API": "https://api.example.com"])
        #expect(env.url("API", default: defaultURL).absoluteString == "https://api.example.com")
        #expect(env.url("MISSING", default: defaultURL) == defaultURL)
    }

    // MARK: - Array

    @Test("Array parsing")
    func arrayParsing() {
        let env = Env(["HOSTS": "a,b,c"])
        #expect(env.array("HOSTS") == ["a", "b", "c"])
        #expect(env.array("MISSING") == nil)
    }

    @Test("Array with spaces")
    func arrayWithSpaces() {
        let env = Env(["HOSTS": "a, b , c"])
        #expect(env.array("HOSTS") == ["a", "b", "c"])
    }

    @Test("Array custom separator")
    func arrayCustomSeparator() {
        let env = Env(["HOSTS": "a:b:c"])
        #expect(env.array("HOSTS", separator: ":") == ["a", "b", "c"])
    }

    @Test("Array with default")
    func arrayDefault() {
        let env = Env(["HOSTS": "a,b"])
        #expect(env.array("HOSTS", default: ["x"]) == ["a", "b"])
        #expect(env.array("MISSING", default: ["x", "y"]) == ["x", "y"])
    }

    @Test("Array filters empty")
    func arrayFiltersEmpty() {
        let env = Env(["HOSTS": "a,,b,"])
        #expect(env.array("HOSTS") == ["a", "b"])
    }

    // MARK: - Data

    @Test("Data UTF8")
    func dataUtf8() {
        let env = Env(["TEXT": "hello"])
        let data = env.data("TEXT")
        #expect(data == "hello".data(using: .utf8))
    }

    @Test("Base64 decoding")
    func base64Decoding() {
        let env = Env(["ENCODED": "SGVsbG8gV29ybGQ="])  // "Hello World"
        let data = env.base64("ENCODED")
        #expect(String(data: data!, encoding: .utf8) == "Hello World")
    }

    @Test("Base64 invalid")
    func base64Invalid() {
        let env = Env(["ENCODED": "not-valid-base64!!!"])
        #expect(env.base64("ENCODED") == nil)
    }
}

@Suite("Env Required Getters")
struct EnvRequiredTests {
    @Test("Require present key")
    func requirePresent() throws {
        let env = Env(["KEY": "value"])
        #expect(try env.require("KEY") == "value")
    }

    @Test("Require missing key throws")
    func requireMissing() {
        let env = Env()
        #expect(throws: EnvError.missingRequired("KEY")) {
            try env.require("KEY")
        }
    }

    @Test("Require Int valid")
    func requireIntValid() throws {
        let env = Env(["PORT": "8080"])
        #expect(try env.requireInt("PORT") == 8080)
    }

    @Test("Require Int invalid throws")
    func requireIntInvalid() {
        let env = Env(["PORT": "abc"])
        #expect(throws: EnvError.invalidType(key: "PORT", expected: "Int", actual: "abc")) {
            try env.requireInt("PORT")
        }
    }

    @Test("Require Double valid")
    func requireDoubleValid() throws {
        let env = Env(["RATE": "3.14"])
        #expect(try env.requireDouble("RATE") == 3.14)
    }

    @Test("Require Bool valid")
    func requireBoolValid() throws {
        let env = Env(["DEBUG": "true"])
        #expect(try env.requireBool("DEBUG") == true)
    }

    @Test("Require Bool invalid throws")
    func requireBoolInvalid() {
        let env = Env(["DEBUG": "maybe"])
        #expect(throws: EnvError.invalidType(key: "DEBUG", expected: "Bool", actual: "maybe")) {
            try env.requireBool("DEBUG")
        }
    }

    @Test("Require URL valid")
    func requireURLValid() throws {
        let env = Env(["API": "https://api.example.com"])
        #expect(try env.requireURL("API").absoluteString == "https://api.example.com")
    }
}
