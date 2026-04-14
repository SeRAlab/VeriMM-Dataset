module top_module(
  input ADDSUB,
  input [26:0] D_DATA,
  input INMODE2,
  input [26:0] PREADD_AB,
  output [26:0] AD
);wire [26:0] D_DATA_mux;

  assign D_DATA_mux = INMODE2 ? D_DATA : 27'b0;
  assign AD = ADDSUB ? (D_DATA_mux - PREADD_AB) : (D_DATA_mux + PREADD_AB);

endmodule