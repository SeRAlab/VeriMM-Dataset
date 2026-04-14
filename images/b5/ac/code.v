module top_module(
  input [1:0] x_real,
  input [1:0] x_imag,
  input [1:0] y_real,
  input [1:0] y_imag,
  output [1:0] z_real,
  output [1:0] z_imag
);assign z_real = x_real + y_real;
  assign z_imag = x_imag + y_imag;

endmodule