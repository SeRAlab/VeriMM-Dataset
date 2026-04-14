module rrt(
    input clk,
    input rst,
    input [7:0] current_x,
    input [7:0] current_y,
    input [7:0] target_x,
    input [7:0] target_y,
    output reg [7:0] new_x,
    output reg [7:0] new_y
);
    reg [7:0] random_x;
    reg [7:0] random_y;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            new_x <= current_x;
            new_y <= current_y;
        end else begin
            // Generate random points (for simplicity, we use fixed values here)
            random_x <= $random % 256; 
            random_y <= $random % 256;

            // Move towards the random point
            if (new_x < random_x) begin
                new_x <= new_x + 1;
            end else if (new_x > random_x) begin
                new_x <= new_x - 1;
            end

            if (new_y < random_y) begin
                new_y <= new_y + 1;
            end else if (new_y > random_y) begin
                new_y <= new_y - 1;
            end
        end
    end
endmodule