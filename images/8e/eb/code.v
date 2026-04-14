module top_module(
  input [15:0] input_data,
  output [15:0] encrypted_output
);wire [7:0] A;
  wire [7:0] B;

  assign A = input_data[15:8];
  assign B = input_data[7:0];

  wire [7:0] A_mult;
  wire [7:0] B_mult;

  assign A_mult = A * 3;
  assign B_mult = B * 5;

  wire [7:0] A_plus_B_mult;
  wire [7:0] B_plus_A_mult;

  assign A_plus_B_mult = A_mult + B;
  assign B_plus_A_mult = B_mult + A;

  assign encrypted_output = {A_plus_B_mult, B_plus_A_mult};

endmodule