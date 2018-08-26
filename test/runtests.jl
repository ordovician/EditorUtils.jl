using EditorUtils
using Test

@testset "All Tests" begin

    @testset "capitalize strings" begin
        @test capitalize("hello") == "Hello"
        @test capitalize("HELLO") == "Hello"
        @test capitalize("heLLo") == "Hello"
        @test capitalize("HELLO_WORLD") == "Hello_world"
        @test capitalize.(["hello", "world"]) == ["Hello", "World"]
    end
    
    @testset "camel case to snake case" begin
        @test snake_case("hello") == "hello"
        @test snake_case("HelloWorld") == "hello_world"
        @test snake_case("helloWorld") == "hello_world"
    end
    
    @testset "snake case to camel case" begin
        @test snake_case("hello") == "hello"
        @test snake_case("HelloWorld") == "hello_world"
    end
    
    
end