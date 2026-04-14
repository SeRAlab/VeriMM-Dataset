module top_module(
  input [3:0] A,
  input [3:0] B,
  input SUB,
  output [3:0] SUM,
  output OV,
  output ZERO
);wire [3:0] temp_sum;
  wire [3:0] twos_complement_b;
  
  assign twos_complement_b = SUB ? (~B + 1) : B;
  assign temp_sum = A + twos_complement_b;
  
  assign OV = (temp_sum > 15) || (temp_sum < 0);
  assign ZERO = (temp_sum == 0);
  
  assign SUM = SUB ? temp_sum : A + B;
  
endmodule