module top_module(
  input [31:0] data,
  input [3:0] distance,
  output [31:0] result
);// Perform arithmetic left shift using << operator
  // Fill leftmost bits with sign bit of input data
  assign result = (data >>> {distance, {28{data[31]}}}) << distance;

endmodule