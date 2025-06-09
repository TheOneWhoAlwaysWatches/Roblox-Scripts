-- No Cooldown V5

local RunService = game:GetService("RunService")

-- Override wait and task.wait to use PostSimulation yield (most aggressive)
hookfunction(wait, function()
    return RunService.PostSimulation:Wait()
end)

hookfunction(task.wait, function()
    return RunService.PostSimulation:Wait()
end)

-- Override delay and spawn to use task.spawn (non-yielding)
hookfunction(delay, function(_, func)
    task.spawn(func)
end)

hookfunction(spawn, function(func)
    task.spawn(func)
end)