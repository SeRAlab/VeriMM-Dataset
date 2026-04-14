module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'he6fe;
      1: q = 16'h535e;
      2: q = 16'h28b5;
      3: q = 16'hc033;
      4: q = 16'hbcc4;
      5: q = 16'h2ecb;
      6: q = 16'h6070;
      7: q = 16'h5dd0;
    endcase

endmodule
