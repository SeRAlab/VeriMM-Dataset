module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h57c8;
      1: q = 16'h398b;
      2: q = 16'h49e7;
      3: q = 16'h8b4c;
      4: q = 16'hc6ce;
      5: q = 16'hb280;
      6: q = 16'h28d3;
      7: q = 16'h9e29;
    endcase

endmodule
