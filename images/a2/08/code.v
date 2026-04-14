module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h1df8;
      1: q = 16'h4402;
      2: q = 16'h7af8;
      3: q = 16'hcce8;
      4: q = 16'h1b7f;
      5: q = 16'he64c;
      6: q = 16'h9f9e;
      7: q = 16'hcc7d;
    endcase

endmodule
