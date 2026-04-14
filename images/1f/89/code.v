module AStarPathFinder (
    input [4:0] x,         // Current X position (5 bits, max 31)
    input [4:0] y,         // Current Y position (5 bits, max 31)
    input [4:0] goal_x,    // Goal X position (5 bits, max 31)
    input [4:0] goal_y,    // Goal Y position (5 bits, max 31)
    output reg [4:0] next_x, // Next X position
    output reg [4:0] next_y  // Next Y position
);

always @(*) begin
    // Simple heuristic: move towards the goal position
    if (x < goal_x) begin
        next_x = x + 1;  // Move right
    end else if (x > goal_x) begin
        next_x = x - 1;  // Move left
    end else begin
        next_x = x;      // Stay in the same column
    end
    
    if (y < goal_y) begin
        next_y = y + 1;  // Move down
    end else if (y > goal_y) begin
        next_y = y - 1;  // Move up
    end else begin
        next_y = y;      // Stay in the same row
    end
end

endmodule