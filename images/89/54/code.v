module top_module(
input1,
input2,
operation,
carryOutAdder,
result
);input [17:0] input1;
input [17:0] input2;
input [1:0] operation;
output wire [17:0] result;
output wire carryOutAdder;
parameter carry_in = 1'b0;

assign {result}= (operation[0] & operation[1]) ? {input1 ^ input2} :result ;
assign {result}= (operation[0] & ~operation[1]) ? {carry_in + input1 + input2} :result;
assign {result}= (~operation[0] & operation[1]) ? {input1 | input2} :result ;
assign {result}= (~operation[0] & ~operation[1]) ? {input1 & input2} :result ;
endmodule