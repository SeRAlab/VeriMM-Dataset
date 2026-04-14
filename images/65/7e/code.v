module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h3f67;
      1: q = 16'ha3e2;
      2: q = 16'h4026;
      3: q = 16'h7afc;
      4: q = 16'h1eb5;
      5: q = 16'hfa4c;
      6: q = 16'he9c4;
      7: q = 16'h379e;
    endcase

endmodule
