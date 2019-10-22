"""
Collection of functions which a practical to use when editing sourcs code, such as
* capitalizing words
* switch between snake case and camel case of an identifier
* toggle case
"""
module EditorUtils

export capitalize, length_of_longest, camel_case, snake_case, toggle, spaced_words, camel_split

"Capitalize strings such as \"HELLO\" to \"Hello\" or \"hello\" to \"Hello\""
function capitalize(s::AbstractString)
    if isempty(s)
        return s
    end
    uppercase(s[1:1]) * lowercase(s[2:end])
end

"Find the length of longest string in list. So for strings `[\"aa\", \"bbb\", \"c\"]` the result would be 3, since thel longest string \"bbb\" is 3 characters long"
function length_of_longest(strings::Vector{<: AbstractString})
    reduce(strings, init = 0) do len, s
        max(len, length(s))
    end
end

"Turns string \"hello_world\" into \"HelloWorld\""
camel_case(s::AbstractString) =  join(capitalize.(split(s, "_")))

const EOFChar = Char(0xC0) # Using illegal UTF8 as sentinel

"Split camel cased word into multiple strings. Turns \"HelloWorldWide\" into [\"hello\", \"world\", \"wide\"]"
function camel_split(s::AbstractString)    
    words = String[]
    i = 1       # start position in string
    j = 0       # current position
    
    function peek()
        k = nextind(s, j)
        if k > lastindex(s)
            return EOFChar
        end
        s[k]
    end
    
    function scan(pred::Function)
        ch = peek()
        while ch != EOFChar && (pred(ch) || !isletter(ch))
            j += 1
            ch = peek()
        end
        ch 
    end
    
    ch = peek()
    while ch != EOFChar
       ch = if islowercase(ch)
                scan(islowercase)
            else
                scan(isuppercase)
                scan(islowercase)
            end
       @debug "Added word '$(lowercase(s[i:j]))'" maxlog=6
       push!(words, lowercase(s[i:j]))
       i = j + 1
    end
    words
end

"""
    snake_case(string)
Turns string \"HelloWorld\" into \"hello_world\"
"""
snake_case(s::AbstractString) = join(camel_split(s), "_")

"""
    spaced_words(string)
Turns \"HELLO_THERE_FRIENDS\" into \"Hello There Friends\"
"""
spaced_words(s::AbstractString) = join(capitalize.(split(s, "_")), " ")

"""
    camel_case()
Convert string on clipboard in snake case into camel case. Result placed on clipboard.
"""
function camel_case()
    s = camel_case(clipboard())
    clipboard(s)
    s
end

"""
    snake_case()
Convert string on clipboard in camel case into snake case. Result placed on clipboard.
"""
function snake_case()
    s = snake_case(clipboard())
    clipboard(s)
    s
end

"""
    toggle_case(string)
Toggle between camel case and snake case
"""
function toggle_case(s::AbstractString)
    if isempty(search(s, "_")) || any(isuppercase, s)
        snake_case(s)
    else
        camel_case(s)
    end
end

"""
    toggle_case()
Toggle between camel case and snake case on string found on clipboard. Result placed
on clipboard.
"""
function toggle_case()
    s = toggle_case(clipboard())
    clipboard(s)
    s
end

end # module
