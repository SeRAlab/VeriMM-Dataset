module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hc342;
      1: q = 16'he505;
      2: q = 16'h1ca4;
      3: q = 16'h93d3;
      4: q = 16'hd2e6;
      5: q = 16'hbbfa;
      6: q = 16'h43e8;
      7: q = 16'hb9e6;
    endcase

endmodule
