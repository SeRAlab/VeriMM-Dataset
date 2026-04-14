module top_module(
  input  wire i0,
  input  wire i1,
  input  wire en,
  output wire o
);wire n_en;
  wire n0;
  wire n1;
  wire n2;
  wire n3;

  assign n_en = ~en;
  assign n0 = ~i0;
  assign n1 = ~i1;
  assign n2 = n_en & n0;
  assign n3 = n_en & n1;
  assign o = (en) ? (i1 & ~n2) | (i0 & ~n3) : (n2 | n3);

endmodule