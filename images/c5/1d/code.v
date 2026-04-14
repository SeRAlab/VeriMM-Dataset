module add_sub (
  input [3:0] A,
  input [3:0] B,
  input C,
  output [3:0] S,
  output [3:0] D
);

  wire [4:0] temp;

  assign temp = C ? (A - B) : (A + B);

  assign S = temp[3:0];
  assign D = temp[4] ? (temp[3:0] - 16) : temp[3:0];

endmodule