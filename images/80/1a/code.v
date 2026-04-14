module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h5a72;
      1: q = 16'hb847;
      2: q = 16'hefc2;
      3: q = 16'hfe56;
      4: q = 16'h9c12;
      5: q = 16'hfe49;
      6: q = 16'h9242;
      7: q = 16'h309a;
    endcase

endmodule
