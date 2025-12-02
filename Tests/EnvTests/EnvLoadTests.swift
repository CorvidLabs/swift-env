import Testing
import Foundation
@testable import Env

@Suite("Env Loading")
struct EnvLoadTests {
    @Test("Load from contents")
    func loadContents() throws {
        let content = """
        API_KEY=secret123
        DEBUG=true
        PORT=8080
        """
        let env = try Env.load(contents: content)
        #expect(env["API_KEY"] == "secret123")
        #expect(env["DEBUG"] == "true")
        #expect(env["PORT"] == "8080")
    }

    @Test("Load with interpolation")
    func loadWithInterpolation() throws {
        let content = """
        BASE_URL=https://api.example.com
        FULL_URL=${BASE_URL}/v1
        """
        let env = try Env.load(contents: content, interpolate: true)
        #expect(env["FULL_URL"] == "https://api.example.com/v1")
    }

    @Test("Load without interpolation")
    func loadWithoutInterpolation() throws {
        let content = """
        BASE_URL=https://api.example.com
        FULL_URL=${BASE_URL}/v1
        """
        let env = try Env.load(contents: content, interpolate: false)
        #expect(env["FULL_URL"] == "${BASE_URL}/v1")
    }

    @Test("Load missing file throws")
    func loadMissingFile() {
        #expect(throws: EnvError.fileNotFound("nonexistent.env")) {
            try Env.load(from: "nonexistent.env")
        }
    }

    @Test("Load or process fallback")
    func loadOrProcess() {
        // Should not throw, returns process env on failure
        let env = Env.loadOrProcess(from: "nonexistent.env")
        #expect(env.has("PATH"))
    }
}

@Suite("Env Errors")
struct EnvErrorTests {
    @Test("Error descriptions")
    func errorDescriptions() {
        let fileNotFound = EnvError.fileNotFound("/path/to/.env")
        #expect(fileNotFound.errorDescription?.contains("not found") == true)

        let missingRequired = EnvError.missingRequired("API_KEY")
        #expect(missingRequired.errorDescription?.contains("API_KEY") == true)

        let invalidType = EnvError.invalidType(key: "PORT", expected: "Int", actual: "abc")
        #expect(invalidType.errorDescription?.contains("PORT") == true)
        #expect(invalidType.errorDescription?.contains("Int") == true)

        let parseError = EnvError.parseError(line: 5, message: "Invalid syntax")
        #expect(parseError.errorDescription?.contains("line 5") == true)
    }

    @Test("Error equality")
    func errorEquality() {
        #expect(EnvError.fileNotFound("a") == EnvError.fileNotFound("a"))
        #expect(EnvError.fileNotFound("a") != EnvError.fileNotFound("b"))

        #expect(EnvError.missingRequired("KEY") == EnvError.missingRequired("KEY"))
        #expect(EnvError.missingRequired("KEY") != EnvError.missingRequired("OTHER"))

        #expect(
            EnvError.invalidType(key: "K", expected: "Int", actual: "x") ==
            EnvError.invalidType(key: "K", expected: "Int", actual: "x")
        )

        #expect(EnvError.parseError(line: 1, message: "err") == EnvError.parseError(line: 1, message: "err"))
    }
}
