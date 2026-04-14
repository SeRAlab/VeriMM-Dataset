module AStarSearch(
    input [2:0] current_x, // Current X position (0 to 4)
    input [2:0] current_y, // Current Y position (0 to 4)
    input [2:0] target_x,   // Target X position (0 to 4)
    input [2:0] target_y,   // Target Y position (0 to 4)
    input [24:0] obstacles,  // 5x5 grid represented as a bitmask
    output reg [2:0] next_x,  // Next X position (0 to 4)
    output reg [2:0] next_y   // Next Y position (0 to 4)
);

    always @(*) begin
        // Basic move towards target, avoiding obstacles
        next_x = current_x;
        next_y = current_y;

        if (current_x < target_x && !obstacles[(current_x + 1) + current_y * 5]) begin
            next_x = current_x + 1;
        end else if (current_x > target_x && !obstacles[(current_x - 1) + current_y * 5]) begin
            next_x = current_x - 1;
        end

        if (current_y < target_y && !obstacles[current_x + (current_y + 1) * 5]) begin
            next_y = current_y + 1;
        end else if (current_y > target_y && !obstacles[current_x + (current_y - 1) * 5]) begin
            next_y = current_y - 1;
        end
    end
endmodule