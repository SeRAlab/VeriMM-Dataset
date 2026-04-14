module top_module(
  output [26:0] AD,
  input ADDSUB,
  input [26:0] D_DATA,
  input INMODE2,
  input [26:0] PREADD_AB
);reg [26:0] D_DATA_mux;
wire [26:0] preadd_out;

assign D_DATA_mux = INMODE2 ? D_DATA : 27'b0;

// pre-addition operation
assign preadd_out = ADDSUB ? (D_DATA_mux - PREADD_AB) : (D_DATA_mux + PREADD_AB);

// final output
assign AD = preadd_out;

endmodule