module AStar(
    input clk,
    input reset,
    input [3:0] current_node,
    input [3:0] target_node,
    input [3:0] cost_function, // Cost to reach the current node
    input [3:0] heuristic_function, // Estimated cost from current node to target
    output reg [3:0] next_node
);
    reg [3:0] best_next_node;
    reg [7:0] best_cost;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_node <= 4'b0000;
            best_cost <= 8'hFF; // Initialize to maximum
        end else begin
            // Calculate total cost
            if ((cost_function + heuristic_function) < best_cost) begin
                best_cost <= cost_function + heuristic_function;
                best_next_node <= current_node + 1; // For simplicity, increment current node
            end
            next_node <= best_next_node;
        end
    end
endmodule