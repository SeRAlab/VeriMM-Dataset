module portfolio_optimization(
    input [7:0] return1,
    input [7:0] return2,
    input [7:0] return3,
    input [7:0] weight1,
    input [7:0] weight2,
    input [7:0] weight3,
    output reg [15:0] total_weighted_return
);
    always @(*) begin
        total_weighted_return = (return1 * weight1) + (return2 * weight2) + (return3 * weight3);
    end
endmodule