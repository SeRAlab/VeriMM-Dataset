module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h1fc6;
      1: q = 16'hd3c9;
      2: q = 16'h2491;
      3: q = 16'h9a53;
      4: q = 16'h9f68;
      5: q = 16'hd7f3;
      6: q = 16'hdc6f;
      7: q = 16'h6086;
    endcase

endmodule
