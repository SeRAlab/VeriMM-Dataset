module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hfeb8;
      1: q = 16'h014d;
      2: q = 16'hce04;
      3: q = 16'hcf17;
      4: q = 16'h74d4;
      5: q = 16'h1deb;
      6: q = 16'hcba8;
      7: q = 16'hbe3b;
    endcase

endmodule
