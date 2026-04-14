module portfolio_optimization(
    input [3:0] weight1,
    input [3:0] weight2,
    input [3:0] weight3,
    input [3:0] return1,
    input [3:0] return2,
    input [3:0] return3,
    output reg [7:0] expected_return
);
    always @(*) begin
        expected_return = (weight1 * return1 + weight2 * return2 + weight3 * return3) >> 2; // Shift right to manage overflow
    end
endmodule