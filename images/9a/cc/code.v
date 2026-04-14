module top_module(
  input [3:0] in1,
  input [3:0] in2,
  input [3:0] in3,
  input [3:0] in4,
  output eq,
  output gt
);wire [3:0] max_value = 4'b0111; // Binary value of 7

  assign eq = (in1 == in2) && (in2 == in3) && (in3 == in4); // Check if all inputs are equal
  
  assign gt = (in1 > max_value) || (in2 > max_value) || (in3 > max_value) || (in4 > max_value); // Check if any input is greater than 7

endmodule