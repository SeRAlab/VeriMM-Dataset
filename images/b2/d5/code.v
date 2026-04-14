module top_module(
  input logic [1:0] arrbkw,
  output logic y0,
  output logic y1
);assign y0 = arrbkw[1];
  assign y1 = arrbkw[0];

endmodule