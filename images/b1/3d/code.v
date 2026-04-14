module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h3f55;
      1: q = 16'h97d9;
      2: q = 16'h13c1;
      3: q = 16'h080c;
      4: q = 16'h94a9;
      5: q = 16'h2f98;
      6: q = 16'hca63;
      7: q = 16'hbf88;
    endcase

endmodule
