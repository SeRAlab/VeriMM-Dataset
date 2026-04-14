module AStarSearch(
    input [3:0] current_node,
    input [3:0] goal_node,
    input [3:0] heuristic,
    output reg is_goal,
    output reg [3:0] next_node
);
    always @(*) begin
        is_goal = (current_node == goal_node);
        if (is_goal) begin
            next_node = current_node; // No next node if we reached the goal
        end else begin
            // Simple heuristic-based next node selection
            if (heuristic < 4) begin
                next_node = current_node + 1; // Move to the next node
            end else begin
                next_node = current_node - 1; // Move to the previous node
            end
        end
    end
endmodule