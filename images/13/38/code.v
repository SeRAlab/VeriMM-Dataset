module AStarAlgorithm (
    input clk,
    input rst,
    input [4:0] current_state,
    input [4:0] goal_state,
    input [4:0] heuristic_value,
    output reg [4:0] next_state
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_state <= 5'b00000;
        end else begin
            // Simplified A* logic: move towards the goal state
            if (current_state < goal_state) begin
                next_state <= current_state + 1; // Move up
            end else if (current_state > goal_state) begin
                next_state <= current_state - 1; // Move down
            end else begin
                next_state <= current_state; // Reached the goal
            end
        end
    end
endmodule