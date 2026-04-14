module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h4a6c;
      1: q = 16'hd742;
      2: q = 16'h6f2b;
      3: q = 16'h1e63;
      4: q = 16'hcc8e;
      5: q = 16'h63ac;
      6: q = 16'h6de1;
      7: q = 16'hd387;
    endcase

endmodule
