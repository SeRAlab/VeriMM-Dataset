module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'he283;
      1: q = 16'h9e34;
      2: q = 16'hefeb;
      3: q = 16'h48ce;
      4: q = 16'h2d00;
      5: q = 16'hf048;
      6: q = 16'h4b9e;
      7: q = 16'h6f3f;
    endcase

endmodule
