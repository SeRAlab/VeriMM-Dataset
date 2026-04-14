module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h27fa;
      1: q = 16'hecd4;
      2: q = 16'hcb8e;
      3: q = 16'h6d11;
      4: q = 16'h5ee4;
      5: q = 16'hbc5d;
      6: q = 16'h68e1;
      7: q = 16'h6934;
    endcase

endmodule
