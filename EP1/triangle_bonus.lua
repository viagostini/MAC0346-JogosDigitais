local triangle_bonus = {}

enum = {
  ["sword"] = 1,
  ["axe"] = 2,
  ["lance"] = 3,
  ["wind"] = 4,
  ["thunder"] = 5,
  ["fire"] = 6
}

kinds = {
    ["sword"] = "physical",
    ["axe"] = "physical",
    ["lance"] = "physical",
    ["wind"] = "magical",
    ["thunder"] = "magical",
    ["fire"] = "magical"
}

for i=1,6 do
  triangle_bonus[i] = {}
  for j=1,6 do
    triangle_bonus[i][j] = 0
  end
end

triangle_bonus[1][2] = 1
triangle_bonus[1][3] = -1
triangle_bonus[2][1] = -1
triangle_bonus[2][2] = 1
triangle_bonus[3][1] = 1
triangle_bonus[3][2] = -1
triangle_bonus[4][5] = 1
triangle_bonus[4][6] = -1
triangle_bonus[5][4] = -1
triangle_bonus[5][6] = 1
triangle_bonus[6][4] = 1
triangle_bonus[6][5] = -1

return triangle_bonus
