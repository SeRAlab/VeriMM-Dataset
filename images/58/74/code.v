module top_module(
  input [3:0] A,
  input [3:0] B,
  input mode,
  output [3:0] Y,
  output COUT,
  output BOUT
);wire [3:0] B_comp;
  assign B_comp = ~B + 1; // Two's complement of B

  wire [4:0] Y_temp;
  assign Y_temp = A + (mode ? B_comp : B); // Perform addition or subtraction based on mode input

  assign Y = Y_temp[3:0]; // Output the result
  assign COUT = Y_temp[4]; // Output carry-out for addition
  assign BOUT = Y_temp[4] ^ mode; // Output borrow-out for subtraction

endmodule