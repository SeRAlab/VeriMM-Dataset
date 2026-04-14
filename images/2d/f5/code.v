module rrt_tree (
    input clk,
    input reset,
    input [7:0] start_x,
    input [7:0] start_y,
    input [7:0] target_x,
    input [7:0] target_y,
    output reg [7:0] new_node_x,
    output reg [7:0] new_node_y
);
    reg [7:0] random_x;
    reg [7:0] random_y;
    reg [7:0] nearest_x;
    reg [7:0] nearest_y;

    // Simple random generation (for illustrative purposes)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            new_node_x <= start_x;
            new_node_y <= start_y;
        end else begin
            // Mock random point, in practice this could be a more complex random generator
            random_x <= $random % 256;
            random_y <= $random % 256;

            // Find nearest point (in this case just using a simple logic)
            nearest_x <= new_node_x; // For this example, we assume the last node is the nearest
            nearest_y <= new_node_y;

            // Create new node in the direction of the random point
            new_node_x <= nearest_x + (random_x - nearest_x) / 2; // Move halfway towards random
            new_node_y <= nearest_y + (random_y - nearest_y) / 2; // Move halfway towards random
        end
    end
endmodule