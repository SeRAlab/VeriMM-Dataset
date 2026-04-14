module portfolio_opt (
    input [4:0] weight1, 
    input [4:0] weight2, 
    input [4:0] weight3, 
    input [4:0] return1, 
    input [4:0] return2, 
    input [4:0] return3, 
    output reg [9:0] expected_return
);
    always @(*) begin
        expected_return = (weight1 * return1 + weight2 * return2 + weight3 * return3);
    end
endmodule