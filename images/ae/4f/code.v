module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h8b63;
      1: q = 16'hf2f5;
      2: q = 16'h6452;
      3: q = 16'h6943;
      4: q = 16'hdb81;
      5: q = 16'h24a0;
      6: q = 16'hd3a5;
      7: q = 16'hddfb;
    endcase

endmodule
