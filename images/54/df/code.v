module top_module(ena, inv, outv);input ena;
  input [1:0] inv;
  output [3:0] outv;
  
  wire ena;
  wire [1:0] inv;
  wire [3:0] outv;

  assign outv[3] = ~inv[1] & ~inv[0] & ena;
  assign outv[2] = ~inv[1] & inv[0] & ena;
  assign outv[1] = inv[1] & ~inv[0] & ena;
  assign outv[0] = inv[1] & inv[0] & ena;

endmodule