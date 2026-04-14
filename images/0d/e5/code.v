module AStarPathfinder (
    input wire clk,
    input wire rst,
    input wire [3:0] current_x,
    input wire [3:0] current_y,
    input wire [3:0] target_x,
    input wire [3:0] target_y,
    input wire [15:0] grid, // 4x4 grid, 0 = free, 1 = obstacle
    output reg [3:0] next_x,
    output reg [3:0] next_y
);
    reg [1:0] direction; // 00 = up, 01 = right, 10 = down, 11 = left

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_x <= current_x;
            next_y <= current_y;
        end else begin
            // Simplified A* logic: naive approach just moves towards the target
            if (current_y > target_y && grid[current_x + (current_y-1)*4] == 0)
                direction <= 0; // move up
            else if (current_x < target_x && grid[current_x + 1 + current_y*4] == 0)
                direction <= 1; // move right
            else if (current_y < target_y && grid[current_x + (current_y+1)*4] == 0)
                direction <= 2; // move down
            else if (current_x > target_x && grid[current_x - 1 + current_y*4] == 0)
                direction <= 3; // move left
            
            // Update next position based on direction
            case (direction)
                0: next_y <= current_y - 1; // move up
                1: next_x <= current_x + 1; // move right
                2: next_y <= current_y + 1; // move down
                3: next_x <= current_x - 1; // move left
                default: begin
                    next_x <= current_x;
                    next_y <= current_y;
                end
            endcase
        end
    end
endmodule