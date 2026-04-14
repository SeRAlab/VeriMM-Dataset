module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h1b36;
      1: q = 16'hc442;
      2: q = 16'h2e52;
      3: q = 16'h2af9;
      4: q = 16'ha5d6;
      5: q = 16'h1b6d;
      6: q = 16'h4cce;
      7: q = 16'hb952;
    endcase

endmodule
