module rrt (
    input wire clk,
    input wire reset,
    input wire [7:0] start_x,
    input wire [7:0] start_y,
    input wire [7:0] goal_x,
    input wire [7:0] goal_y,
    input wire [7:0] random_x,
    input wire [7:0] random_y,
    output reg [7:0] closest_x,
    output reg [7:0] closest_y,
    output reg goal_reached
);
    parameter DIST_THRESHOLD = 8'd10; // Distance threshold for reaching the goal

    reg [7:0] current_dist;
    reg [7:0] goal_dist;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            closest_x <= start_x;
            closest_y <= start_y;
            goal_reached <= 1'b0;
        end else begin
            // Calculate distance to current random point
            current_dist <= ((random_x - closest_x) * (random_x - closest_x)) + ((random_y - closest_y) * (random_y - closest_y));
            goal_dist <= ((goal_x - closest_x) * (goal_x - closest_x)) + ((goal_y - closest_y) * (goal_y - closest_y));
            
            // Update closest point if random point is closer to the goal
            if (goal_dist > ((goal_x - random_x) * (goal_x - random_x)) + ((goal_y - random_y) * (goal_y - random_y))) begin
                closest_x <= random_x;
                closest_y <= random_y;
            end

            // Check if the goal is reached
            if (goal_dist < DIST_THRESHOLD * DIST_THRESHOLD) begin
                goal_reached <= 1'b1;
            end
        end
    end
endmodule