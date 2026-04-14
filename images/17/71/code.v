module RRT_Node (
    input [7:0] random_x,
    input [7:0] random_y,
    input [7:0] target_x,
    input [7:0] target_y,
    output reg [1:0] direction
);
    always @(*) begin
        if (random_y < target_y)
            direction = 2'b00; // North
        else if (random_x < target_x)
            direction = 2'b01; // East
        else if (random_y > target_y)
            direction = 2'b10; // South
        else if (random_x > target_x)
            direction = 2'b11; // West
        else
            direction = 2'b00; // Default to North if at target
    end
endmodule