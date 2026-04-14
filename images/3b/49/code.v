module AStarSearch (
    input [7:0] current_state,
    input [7:0] heuristic,
    input [7:0] cost,
    output reg [7:0] next_state
);

    reg [15:0] total_cost;

    always @(*) begin
        total_cost = cost + heuristic;
        // Simple logic to determine the next state based on cost
        if (total_cost < 16'hFF) begin
            next_state = current_state + 1; // Example transition
        end else begin
            next_state = current_state; // No transition
        end
    end
endmodule