module PortfolioOptimization(
    input [3:0] weight1,
    input [3:0] weight2,
    input [3:0] weight3,
    input [3:0] return1,
    input [3:0] return2,
    input [3:0] return3,
    output reg [5:0] total_return
);

always @(*) begin
    total_return = (weight1 * return1 + weight2 * return2 + weight3 * return3) >> 2; // Shift right to adjust for fixed-point
end

endmodule