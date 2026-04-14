module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hfe5b;
      1: q = 16'h1a62;
      2: q = 16'hc9c4;
      3: q = 16'h991f;
      4: q = 16'h7a75;
      5: q = 16'h9812;
      6: q = 16'hcc58;
      7: q = 16'hca24;
    endcase

endmodule
