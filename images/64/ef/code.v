module top_module(
  input [3:0] in1,
  input [3:0] in2,
  input [3:0] in3,
  input [3:0] in4,
  input [1:0] sel1,
  input [1:0] sel2,
  output [3:0] out1,
  output [3:0] out2,
  output [3:0] out3,
  output [3:0] out4
);assign out1 = {sel1[0] == 0 ? in1 : in2, sel2[0] == 0 ? in3 : in4};
assign out2 = {sel1[0] == 1 ? in1 : in2, sel2[0] == 1 ? in3 : in4};
assign out3 = {sel1[1] == 0 ? in1 : in2, sel2[1] == 0 ? in3 : in4};
assign out4 = {sel1[1] == 1 ? in1 : in2, sel2[1] == 1 ? in3 : in4};

endmodule