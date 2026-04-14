module top_module(Op1,
    Op2,
    Res);input [0:0]Op1;
  input [0:0]Op2;
  output [0:0]Res;

  wire [0:0]not_Op1;
  wire [0:0]not_Op2;
  wire [0:0]and_result;
  wire [0:0]or_result;
  wire [0:0]not_and_result;

  assign not_Op1 = ~Op1;
  assign not_Op2 = ~Op2;
  assign and_result = Op1 & Op2;
  assign or_result = Op1 | Op2;
  assign not_and_result = ~(Op1 & Op2);

  assign Res = (not_Op1 & Op2) | (Op1 & not_Op2) | not_and_result;

endmodule