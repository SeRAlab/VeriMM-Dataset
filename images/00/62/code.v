module AStarCostCalculator(
    input [3:0] g, // Current cost to reach the node
    input [3:0] h, // Heuristic estimate to reach the goal
    output reg [3:0] f // Total estimated cost
);
    always @(*) begin
        f = g + h; // Calculate total estimated cost
    end
endmodule