import Testing
import Foundation
@testable import Env

@Suite("Env Core")
struct EnvCoreTests {
    @Test("Initialize with dictionary")
    func initWithDictionary() {
        let env = Env(["KEY": "value", "OTHER": "test"])
        #expect(env["KEY"] == "value")
        #expect(env["OTHER"] == "test")
        #expect(env.count == 2)
    }

    @Test("Initialize empty")
    func initEmpty() {
        let env = Env()
        #expect(env.isEmpty)
        #expect(env.count == 0)
    }

    @Test("Dictionary literal initialization")
    func dictionaryLiteral() {
        let env: Env = ["FOO": "bar", "BAZ": "qux"]
        #expect(env["FOO"] == "bar")
        #expect(env["BAZ"] == "qux")
    }

    @Test("Subscript access")
    func subscriptAccess() {
        let env = Env(["KEY": "value"])
        #expect(env["KEY"] == "value")
        #expect(env["MISSING"] == nil)
    }

    @Test("String with default")
    func stringDefault() {
        let env = Env(["KEY": "value"])
        #expect(env.string("KEY", default: "fallback") == "value")
        #expect(env.string("MISSING", default: "fallback") == "fallback")
    }

    @Test("Has key")
    func hasKey() {
        let env = Env(["KEY": "value"])
        #expect(env.has("KEY"))
        #expect(!env.has("MISSING"))
    }

    @Test("Keys property")
    func keysProperty() {
        let env = Env(["A": "1", "B": "2", "C": "3"])
        let keys = Set(env.keys)
        #expect(keys == Set(["A", "B", "C"]))
    }

    @Test("Sequence conformance")
    func sequenceConformance() {
        let env = Env(["A": "1", "B": "2"])
        var collected: [String: String] = [:]
        for (key, value) in env {
            collected[key] = value
        }
        #expect(collected == ["A": "1", "B": "2"])
    }

    @Test("Description")
    func description() {
        let env = Env(["A": "1", "B": "2"])
        #expect(env.description == "Env(2 variables)")
    }

    @Test("Process environment")
    func processEnv() {
        let env = Env.process
        #expect(env.has("PATH"))
    }
}

@Suite("Env Merging")
struct EnvMergingTests {
    @Test("Merge with Env")
    func mergeEnv() {
        let env1 = Env(["A": "1", "B": "2"])
        let env2 = Env(["B": "override", "C": "3"])
        let merged = env1.merging(with: env2)

        #expect(merged["A"] == "1")
        #expect(merged["B"] == "override")
        #expect(merged["C"] == "3")
    }

    @Test("Merge with dictionary")
    func mergeDict() {
        let env = Env(["A": "1"])
        let merged = env.merging(with: ["A": "override", "B": "2"])

        #expect(merged["A"] == "override")
        #expect(merged["B"] == "2")
    }
}
