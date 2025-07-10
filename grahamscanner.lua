
local function tern(cond, if_true, if_false)
       return cond and if_true or if_false
end

local function swap(t, i ,j)
       local temp = t[i]
       t[i] = t[j]
       t[j] = temp
end

local pivot = { x = 0, y = 0}

local function orientation(p, q, r)
       local val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)

       return val == 0 and 0 or tern(val > 0, 1, 2)
end

local function distSq(p1, p2)
       return (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)
end

local function compare(p1, p2)
       local o = orientation(pivot, p1, p2)

       if o == 0 then
              return distSq(pivot, p1) < distSq(pivot, p2)
       end

       return o == 2
end

local function grahamScan(points)
       local n = #points

       if n < 3 then
              print("convex hull not possible")

              return
       end

       local minY = points[1].y
       local minIdx = 1

       for i = 1, n do
              if points[i].y < minY or (points[i].y == minY and points[i].x < points[minIdx].x) then
                     minY = points[i].y
                     minIdx = i
              end
       end

       swap(points, 1, minIdx)
       pivot = points[1]

       
       table.sort(points, compare)

       local hull = {}

       table.insert(hull,points[1])
       table.insert(hull,points[2])
       table.insert(hull,points[3])

       for i = 4, n do
              while #hull >= 2 and orientation(hull[#hull - 1], hull[#hull], points[i]) ~= 2 do
                     table.remove(hull)
              end

              table.insert(hull,points[i])
       end

       return hull
end

local points = {
       {x = 0, y = 3},
       {x = 2, y = 2},
       {x = 1, y = 1},
       {x = 2, y = 1},
       {x = 3, y = 0},
       {x = 0, y = 0},
       {x = 3, y = 3}
}

local result = grahamScan(points)

print("convex hull:")

for _, p in ipairs(result) do
       print("(" .. p.x .. ", " ..  p.y .. ")")
end
