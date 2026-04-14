module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hd46b;
      1: q = 16'h42c8;
      2: q = 16'h2096;
      3: q = 16'h47e9;
      4: q = 16'h816d;
      5: q = 16'h6379;
      6: q = 16'h0125;
      7: q = 16'hcd88;
    endcase

endmodule
