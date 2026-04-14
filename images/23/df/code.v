module rrt_core (
    input clk,
    input reset,
    input [7:0] random_x,
    input [7:0] random_y,
    input [7:0] target_x,
    input [7:0] target_y,
    output reg [7:0] new_x,
    output reg [7:0] new_y,
    output reg reached_target
);
    reg [7:0] nearest_x;
    reg [7:0] nearest_y;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            new_x <= 0;
            new_y <= 0;
            reached_target <= 0;
            nearest_x <= 0;
            nearest_y <= 0;
        end else begin
            // Sample a random point
            nearest_x <= random_x;
            nearest_y <= random_y;

            // Check if the random point is close to the target
            if ((nearest_x - target_x)*(nearest_x - target_x) + 
                (nearest_y - target_y)*(nearest_y - target_y) < 256) begin
                new_x <= nearest_x;
                new_y <= nearest_y;
                reached_target <= 1; // Indicates that the target has been reached
            end else begin
                new_x <= nearest_x;
                new_y <= nearest_y;
                reached_target <= 0;
            end
        end
    end
endmodule