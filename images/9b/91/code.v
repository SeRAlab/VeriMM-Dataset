module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hdcda;
      1: q = 16'h8622;
      2: q = 16'h09a9;
      3: q = 16'haef4;
      4: q = 16'h73b2;
      5: q = 16'ha1c3;
      6: q = 16'h02e3;
      7: q = 16'h6445;
    endcase

endmodule
