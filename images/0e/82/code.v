module PortfolioOptimizer(
    input [7:0] weight1,
    input [7:0] weight2,
    input [7:0] weight3,
    input [15:0] return1,
    input [15:0] return2,
    input [15:0] return3,
    output reg [31:0] total_return
);
    always @(*) begin
        total_return = (weight1 * return1 + weight2 * return2 + weight3 * return3) / 256; // Normalize weights to a total of 256
    end
endmodule