using ProgressMeter

fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

ints(t) = parse.(Int, split(t, r"\D", keepempty = false))
P = ints.(R)
@assert first.(P) == 1:length(P)
M = [P...;;][2:end,:]
ore = M[1,:]
clay = M[2,:]
obsidian_ore, obsidian_clay = M[3,:], M[4,:]
geode_ore, geode_obs = M[5,:],M[6,:]

function blueprintcosts(blueprint)
    costs = zeros(Int,4,4)
    costs[1,1] = ore[blueprint]
    costs[1,2] = clay[blueprint]
    costs[1,3] = obsidian_ore[blueprint]
    costs[2,3] = obsidian_clay[blueprint]
    costs[1,4] = geode_ore[blueprint]
    costs[3,4] = geode_obs[blueprint]
    costs
end

function buildbots(robots, resources, costs, maxrobots, maxtrace, maxg=0, t0=1)
    afforded = MVector(false,false,false,false)
    # afforded = 0
    for t in t0+1:size(resources,2)
        rest = size(resources,2) - t
        for j in 1:4
            resources[j,t] = resources[j,t-1] + robots[j]
        end
        for i in 4:-1:1
            afforded[i] && continue
            # ((afforded & (1 << i)) == (1 << i)) && continue
            if i < 4 && robots[i] ≥ maxrobots[i]
                afforded[i] = true
                # afforded |= (1 << i)
                continue
            end

            afford = if i == 1
                resources[1,t-1] ≥ costs[1,1] && rest > 1
            elseif i == 2
                resources[1,t-1] ≥ costs[1,2] && rest > 2
            elseif i == 3
                resources[2,t-1] ≥ costs[2,3] &&
                resources[1,t-1] ≥ costs[1,3] && rest > 1
            elseif i == 4
                resources[3,t-1] ≥ costs[3,4] &&
                resources[1,t-1] ≥ costs[1,4] && rest > 0
            end
            #afford = all(resources[:,t-1] .≥ costs[:,i])
            if afford
                robots[i] += 1
                for j in 1:4
                    resources[j,t] -= costs[j,i]
                end
                g = buildbots(robots, resources, costs, maxrobots, maxtrace, maxg, t)
                if g > maxg
                    maxtrace[t] = i
                    maxg = g
                end
                for j in 1:4
                    resources[j,t] += costs[j,i]
                end
                #resources[:,t] .+= costs[:,i]
                robots[i] -= 1
                # afforded |= (1 << i)
                afforded[i] = true
                # break
            end
        end
        #=if (afforded & 6)==6  &&
            ((afforded & 8)==8 || robots[2] == 0) &&
            ((afforded & 16)==16 || robots[3] == 0)
            break
        end=#
        if afforded[1] && afforded[2] &&
            (afforded[3] || robots[2] == 0) &&
            (afforded[4] || robots[3] == 0)
            break
        end
    end
    builtnothing = !any(afforded)
    # builtnothing = iszero(afforded)
    if resources[4,end] > maxg && builtnothing
        maxtrace .= 0
        maxg = resources[4,end]
    end
    maxg
end

@assert 1 < minimum(ore)
@assert 1 < minimum(clay)
function evalblueprint(i, maxt = 24)
    robots = [1,0,0,0]
    resources = zeros(Int, 4, maxt)
    resources[:,1] .+= robots
    maxtrace = zeros(Int, size(resources, 2))
    costs = blueprintcosts(i)
    maxrobots = [
        maximum(costs[1,2:end])
        costs[2,3]
        costs[3,4]]

    maxg = buildbots(robots, resources, costs, maxrobots, maxtrace)
    maxg, maxtrace
end
myg, mytrace = evalblueprint(2,24)
myg, mytrace = evalblueprint(1,24)

# sum(i*evalblueprint(i)[1] for i in 1:length(P))

S = @showprogress [i*evalblueprint(i, 24)[1] for i in 1:length(P)]
sum(S)

# part 2
evalblueprint(1, 27)
evalblueprint(1, 27)
@time evalblueprint(1, 25)
@time evalblueprint(1, 26)
@time evalblueprint(1, 32)
@time evalblueprint(1, 28)
@time evalblueprint(1, 29)
@elapsed evalblueprint(1, 30)
@elapsed myg, mytrace = evalblueprint(1, 23)
@elapsed myg, mytrace = evalblueprint(1, 24)
@elapsed myg, mytrace = evalblueprint(1, 25)
@elapsed myg, mytrace = evalblueprint(1, 26)
@elapsed myg, mytrace = evalblueprint(1, 27)
@elapsed myg, mytrace = evalblueprint(1, 28)
@elapsed myg, mytrace = evalblueprint(1, 29)
@elapsed myg, mytrace = evalblueprint(1, 30)
@elapsed myg, mytrace = evalblueprint(1, 31)
@elapsed myg, mytrace = evalblueprint(1, 32) # 56
@elapsed myg, mytrace = evalblueprint(2, 32) # 62
myg
S = @showprogress [evalblueprint(i, 32) for i in 1:3]
prod(first.(S))

S2 = @showprogress [evalblueprint(i, 32) for i in 1:3]
prod(first.(S2))

1+""

function evaltrace(trace, costs)
    robots = [1,0,0,0]
    resources = [0,0,0,0]
    for (t,r) in enumerate(trace)
        resources .+= robots
        if !iszero(r)
            resources .-= costs[:,r]
            if any(resources .< robots)
                return -1
            end

            robots[r] += 1
        end
        print(t, " \t"); show(resources); print("\t"); show(robots)
        if !iszero(r)
            print(" Build ", r)
        end
        println()
    end
end
println(); evaltrace(mytrace, blueprintcosts(1))

display(blueprintcosts(2))

1+""
function evalplan1(robots, resources, i, s, costs, t0)
    for t in 1:s
        afford = if i == 1
            resources[1] ≥ costs[1,1]
        elseif i == 2
            resources[1] ≥ costs[1,2]
        elseif i == 3
            resources[1] ≥ costs[1,3] &&
            resources[2] ≥ costs[2,3]
        elseif i == 4
            resources[1] ≥ costs[1,4] &&
            resources[3] ≥ costs[3,4]
        end
        resources .+= robots
        print(t0 + t, " \t"); show(resources); print("\t"); show(robots)
        if afford
            println(" Build ", i)
            robots[i] += 1
            resources .-= costs[:,i]
        else
            println(" Not enough ", i)
        end
    end
end
function evalplan(S,costs=costs)
    robots = [1,0,0,0]
    resources = [0,0,0,0]
    for i in 1:length(S)
        evalplan1(robots, resources, i, S[i], costs, cumsum([0;S])[i])
    end
    # robots, resources
    resources[4]
end
println();evalplan([0,8,7,11])
cumsum([0,7,8,11])


function permuteplans(t)
    maxg = 0
    for p1 in 0:t
        for p2 in 0:t-p1
            for p3 in 0:t-p1-p2
                for p4 in 0:t-p1-p2-p3
                    if p4 + 1 <= maxg
                        continue
                    end
                end
            end
        end
    end
end
evalplan([10,10,10,10])

robots, resources, costs
function robostep(t, level, robots, resources, costs)
    t += 1
    for i in 1:4
        resources[i] += robots[i]
    end
    maxg = resources[4]
    if t > 4
        return maxg
    end
    g = robostep(t, robots, resources, costs)
    if g > maxg
        maxg = g
    end
        elseif all(resources .≥ costs[:,i])
            resources -= costs[:,i]
            robots[i] += 1

            g = robostep(t, robots, resources, costs)
            if g > maxg
                maxg = g
            end

            robots[i] -= 1
            resources += costs[:,i]
        end
    end
    maxg
end
robostep(1, robots, resources, costs)
