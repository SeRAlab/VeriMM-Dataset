module mux_2to1_en (
  input [7:0] a,
  input [7:0] b,
  input sel,
  input en,
  output [7:0] y
);

  assign y = en ? (sel ? b : a) : 8'b00000000;

endmodule