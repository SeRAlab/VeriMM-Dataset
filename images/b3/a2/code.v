module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h581e;
      1: q = 16'h0a25;
      2: q = 16'hacce;
      3: q = 16'heeb6;
      4: q = 16'h6eca;
      5: q = 16'h58ce;
      6: q = 16'hc3d0;
      7: q = 16'h0600;
    endcase

endmodule
