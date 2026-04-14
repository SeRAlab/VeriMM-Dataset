module AStar (
    input [3:0] current_node,
    input [3:0] goal_node,
    input [3:0] heuristic,
    output reg [3:0] next_node
);

always @(*) begin
    // Simplified logic for selecting the next node
    if (current_node == goal_node) begin
        next_node = current_node; // If at the goal, stay there
    end else if (current_node < goal_node) begin
        next_node = current_node + 1; // Move towards the goal
    end else begin
        next_node = current_node - 1; // Move towards the goal
    end
end

endmodule