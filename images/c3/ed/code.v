module multi_io_module(
  input [3:0] in1,
  input [2:0] in2,
  input in3,
  input clk,
  output [1:0] out1,
  output out2,
  output [2:0] out3,
  output out4
);

  assign out1 = in1[1:0] + in2;
  assign out2 = in1[0] ^ in3;
  assign out3 = {in1, in2};
  assign out4 = in2 & in3;

endmodule