module rrt_step (
    input clk,
    input rst,
    input [7:0] current_x,
    input [7:0] current_y,
    input [7:0] goal_x,
    input [7:0] goal_y,
    input [255:0] obstacle_map, // 16x16 grid
    output reg [7:0] new_x,
    output reg [7:0] new_y,
    output reg valid,
    output reg reached
);

reg [7:0] rand_dir_x;
reg [7:0] rand_dir_y;
reg [7:0] step_size = 1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        new_x <= 0;
        new_y <= 0;
        valid <= 0;
        reached <= 0;
    end else begin
        // Generate a random direction towards the goal
        rand_dir_x = (goal_x > current_x) ? current_x + step_size : current_x - step_size;
        rand_dir_y = (goal_y > current_y) ? current_y + step_size : current_y - step_size;

        // Check for boundaries
        if (rand_dir_x < 16 && rand_dir_y < 16) begin
            // Check if the new position is not an obstacle
            if (obstacle_map[{rand_dir_y, rand_dir_x}] == 0) begin
                new_x <= rand_dir_x;
                new_y <= rand_dir_y;
                valid <= 1;
                
                // Check if the new position is near the goal
                if ((new_x == goal_x) && (new_y == goal_y)) begin
                    reached <= 1;
                end else begin
                    reached <= 0;
                end
            end else begin
                valid <= 0;
                reached <= 0;
            end
        end else begin
            valid <= 0;
            reached <= 0;
        end
    end
end

endmodule