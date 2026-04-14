module top_module(
  input [1:0] sel,
  input [3:0] in0,
  input [3:0] in1,
  input [3:0] in2,
  input [3:0] in3,
  output [3:0] out
);wire [3:0] w1,w2,w3,w4;
  assign w1 = (sel == 2'b00) ? in0 : 4'b0000;
  assign w2 = (sel == 2'b01) ? in1 : 4'b0000;
  assign w3 = (sel == 2'b10) ? in2 : 4'b0000;
  assign w4 = (sel == 2'b11) ? in3 : 4'b0000;
  assign out = w1 | w2 | w3 | w4;

endmodule