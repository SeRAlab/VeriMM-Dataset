module top_module(
  input [7:0] in1,
  input [7:0] in2,
  input signed_ctrl,
  output [7:0] out
);wire [8:0] sum;
  
  assign sum = {1'b0, in1} + {signed_ctrl, in2};
  
  assign out = sum[7:0];
  
endmodule