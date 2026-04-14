module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h7db4;
      1: q = 16'h182b;
      2: q = 16'h6097;
      3: q = 16'hd902;
      4: q = 16'h93fd;
      5: q = 16'hc761;
      6: q = 16'hd346;
      7: q = 16'hc0f2;
    endcase

endmodule
