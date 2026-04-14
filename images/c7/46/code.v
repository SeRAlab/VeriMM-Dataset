module mux4to1 (
  input wire A,
  input wire B,
  input wire C,
  input wire D,
  input wire S0,
  input wire S1,
  output wire Y
);

  assign Y = (S1 & S0 & D) | (S1 & ~S0 & C) | (~S1 & S0 & B) | (~S1 & ~S0 & A);

endmodule