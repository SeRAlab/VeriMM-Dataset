module path_cost_calculator (
    input [7:0] H,  // Heuristic cost input
    input [7:0] G,  // Actual cost input
    output reg [8:0] F  // Total cost output
);
    always @(*) begin
        F = G + H;  // Calculate total cost
    end
endmodule