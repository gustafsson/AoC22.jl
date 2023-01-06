using HTTP
using Dates

function login(session)
    ENV["AOC_SESSION"] = session
end

function cookiedict(cookieheader)
    @assert startswith(cookieheader, "Cookie: ")
    _, cookie = split(cookieheader, ": ", limit = 2)
    cookies = split(cookie, "; ")
    kv = split.(cookies, "=", limit = 2)
    Dict(first.(kv) .=> last.(kv))
end

export cookielogin

"""
Get the cookie header from your logged in browser session

    Cookie: ...

"""
cookielogin(cookieheader) = login(cookiedict(cookieheader)["session"])

export downloadinput
function downloadinput(
        day = day(today()),
        year = year(today());
        fn = "input.txt"
        )

    @assert basename(pwd()) == "day$day"
    if isfile(fn)
        println(fn, " exists")
        return fn
    end

    @assert !isempty(get(ENV, "AOC_SESSION", ""))

    cookies = Dict("session" => ENV["AOC_SESSION"])
    url = "https://adventofcode.com/$year/day/$day/input"
    response = HTTP.get(url; cookies, status_exception = false)

    if response.status != 200
        println(response.status, " ", url)
        println(String(response.body))
    else
        open(fn, "w") do f
            write(f, response.body)
        end

        fn
    end
end
