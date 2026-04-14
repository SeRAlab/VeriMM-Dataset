module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h218b;
      1: q = 16'h1409;
      2: q = 16'h777a;
      3: q = 16'h7258;
      4: q = 16'hef38;
      5: q = 16'h5ef7;
      6: q = 16'h15db;
      7: q = 16'hc55a;
    endcase

endmodule
