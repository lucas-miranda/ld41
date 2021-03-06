Math = {}

Math.epsilon = 0.001

Math.approach = (value, target, step) ->
    if value < target
        return math.min(value + step, target)

    return math.max(value - step, target)

Math.sign = (n) ->
    if (n == 0)
        return 0
    elseif (n > 0)
        return 1

    return -1

Math.equalsEstimate = (a, b, tolerance=Math.epsilon) ->
    math.abs(a - b) < tolerance

return Math
