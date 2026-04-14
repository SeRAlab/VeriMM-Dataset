module AStarPathFinder (
    input [1:0] x, // x-coordinate (0 to 2)
    input [1:0] y, // y-coordinate (0 to 2)
    output reg [7:0] min_cost // Minimum cost to reach (x, y)
);
    reg [7:0] cost_grid [0:2][0:2]; // 3x3 cost grid
    integer i, j;

    initial begin
        // Initialize the cost grid (hardcoded)
        cost_grid[0][0] = 0;    // Start point
        cost_grid[0][1] = 1;    // Cost to move right
        cost_grid[0][2] = 2;    // Cost to move right
        cost_grid[1][0] = 1;    // Cost to move down
        cost_grid[1][1] = 2;    // Cost to move down and right
        cost_grid[1][2] = 3;    // Cost to move down
        cost_grid[2][0] = 2;    // Cost to move down
        cost_grid[2][1] = 3;    // Cost to move right
        cost_grid[2][2] = 4;    // Target point
    end

    always @(*) begin
        // Output the minimum cost to reach (x,y)
        min_cost = cost_grid[x][y];
    end
endmodule