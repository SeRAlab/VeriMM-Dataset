module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h9eb6;
      1: q = 16'h9455;
      2: q = 16'ha711;
      3: q = 16'h8469;
      4: q = 16'h3c59;
      5: q = 16'h8527;
      6: q = 16'h2b11;
      7: q = 16'heeea;
    endcase

endmodule
