module AStarSearch(
    input [4:0] start_x,  // Start x-coordinate
    input [4:0] start_y,  // Start y-coordinate
    input [4:0] target_x, // Target x-coordinate
    input [4:0] target_y, // Target y-coordinate
    output [7:0] estimated_cost // Estimated cost to reach the target
);

    wire [4:0] delta_x;
    wire [4:0] delta_y;

    assign delta_x = (start_x > target_x) ? (start_x - target_x) : (target_x - start_x);
    assign delta_y = (start_y > target_y) ? (start_y - target_y) : (target_y - start_y);

    assign estimated_cost = delta_x + delta_y; // Manhattan distance as cost estimate

endmodule