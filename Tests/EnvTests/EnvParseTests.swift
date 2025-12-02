import Testing
import Foundation
@testable import Env

@Suite("Env Parsing")
struct EnvParseTests {
    @Test("Parse simple key=value")
    func parseSimple() throws {
        let parsed = try Env.parse("KEY=value")
        #expect(parsed == ["KEY": "value"])
    }

    @Test("Parse multiple lines")
    func parseMultiple() throws {
        let content = """
        KEY1=value1
        KEY2=value2
        KEY3=value3
        """
        let parsed = try Env.parse(content)
        #expect(parsed == ["KEY1": "value1", "KEY2": "value2", "KEY3": "value3"])
    }

    @Test("Parse with export prefix")
    func parseExport() throws {
        let parsed = try Env.parse("export KEY=value")
        #expect(parsed == ["KEY": "value"])
    }

    @Test("Skip comments")
    func skipComments() throws {
        let content = """
        # This is a comment
        KEY=value
        # Another comment
        """
        let parsed = try Env.parse(content)
        #expect(parsed == ["KEY": "value"])
    }

    @Test("Skip empty lines")
    func skipEmptyLines() throws {
        let content = """
        KEY1=value1

        KEY2=value2

        """
        let parsed = try Env.parse(content)
        #expect(parsed == ["KEY1": "value1", "KEY2": "value2"])
    }

    @Test("Parse double-quoted value")
    func parseDoubleQuoted() throws {
        let parsed = try Env.parse("KEY=\"hello world\"")
        #expect(parsed == ["KEY": "hello world"])
    }

    @Test("Parse single-quoted value")
    func parseSingleQuoted() throws {
        let parsed = try Env.parse("KEY='hello world'")
        #expect(parsed == ["KEY": "hello world"])
    }

    @Test("Parse inline comment")
    func parseInlineComment() throws {
        let parsed = try Env.parse("KEY=value # comment")
        #expect(parsed == ["KEY": "value"])
    }

    @Test("Parse empty value")
    func parseEmptyValue() throws {
        let parsed = try Env.parse("KEY=")
        #expect(parsed == ["KEY": ""])
    }

    @Test("Parse escape sequences")
    func parseEscapeSequences() throws {
        let content = """
        NEWLINE="hello\\nworld"
        TAB="hello\\tworld"
        """
        let parsed = try Env.parse(content)
        #expect(parsed["NEWLINE"] == "hello\nworld")
        #expect(parsed["TAB"] == "hello\tworld")
    }

    @Test("Invalid key throws")
    func invalidKey() {
        #expect(throws: EnvError.self) {
            try Env.parse("123INVALID=value")
        }
    }

    @Test("Valid keys with underscore")
    func validKeysUnderscore() throws {
        let content = """
        _PRIVATE=1
        MY_KEY=2
        __DOUBLE=3
        """
        let parsed = try Env.parse(content)
        #expect(parsed.count == 3)
    }

    @Test("Skip lines without equals")
    func skipNoEquals() throws {
        let content = """
        KEY=value
        this line has no equals
        OTHER=test
        """
        let parsed = try Env.parse(content)
        #expect(parsed == ["KEY": "value", "OTHER": "test"])
    }
}

@Suite("Env Interpolation")
struct EnvInterpolationTests {
    @Test("Interpolate ${VAR} syntax")
    func interpolateBrace() {
        let values = ["NAME": "World", "GREETING": "Hello ${NAME}"]
        let result = Env.interpolate(values, withProcessEnv: false)
        #expect(result["GREETING"] == "Hello World")
    }

    @Test("Interpolate $VAR syntax")
    func interpolateSimple() {
        let values = ["NAME": "World", "GREETING": "Hello $NAME"]
        let result = Env.interpolate(values, withProcessEnv: false)
        #expect(result["GREETING"] == "Hello World")
    }

    @Test("Interpolate nested")
    func interpolateNested() {
        let values = [
            "A": "1",
            "B": "A=${A}",
            "C": "B=${B}"
        ]
        let result = Env.interpolate(values, withProcessEnv: false)
        #expect(result["B"] == "A=1")
        #expect(result["C"] == "B=A=1")
    }

    @Test("Interpolate missing becomes empty")
    func interpolateMissing() {
        let values = ["GREETING": "Hello ${MISSING}"]
        let result = Env.interpolate(values, withProcessEnv: false)
        #expect(result["GREETING"] == "Hello ")
    }

    @Test("Interpolate from process env")
    func interpolateProcessEnv() {
        let values = ["MY_PATH": "Path is ${PATH}"]
        let result = Env.interpolate(values, withProcessEnv: true)
        #expect(result["MY_PATH"]?.contains("/") == true)
    }

    @Test("Multiple interpolations")
    func multipleInterpolations() {
        let values = [
            "FIRST": "Hello",
            "SECOND": "World",
            "COMBINED": "${FIRST} ${SECOND}!"
        ]
        let result = Env.interpolate(values, withProcessEnv: false)
        #expect(result["COMBINED"] == "Hello World!")
    }
}
