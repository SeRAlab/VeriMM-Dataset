module top_module(
    input clk,
    input [3:0] A,
    input [3:0] B,
    output [3:0] OUT
);reg [3:0] sum_reg1, sum_reg2, sum_reg3;

always @(posedge clk) begin
    sum_reg1 <= A + B;
    sum_reg2 <= sum_reg1;
    sum_reg3 <= sum_reg2;
end

assign OUT = sum_reg3;

endmodule