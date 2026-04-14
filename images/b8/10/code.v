module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h3cd8;
      1: q = 16'ha550;
      2: q = 16'h43d8;
      3: q = 16'hbb42;
      4: q = 16'h16ce;
      5: q = 16'h8fbd;
      6: q = 16'h2124;
      7: q = 16'h60b3;
    endcase

endmodule
