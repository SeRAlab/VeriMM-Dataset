module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h9f18;
      1: q = 16'h3d52;
      2: q = 16'hb0b6;
      3: q = 16'h8a0b;
      4: q = 16'h58a9;
      5: q = 16'h2def;
      6: q = 16'h3f3a;
      7: q = 16'h306b;
    endcase

endmodule
