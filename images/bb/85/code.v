module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hf625;
      1: q = 16'hc3f0;
      2: q = 16'had82;
      3: q = 16'hfe90;
      4: q = 16'hbc3a;
      5: q = 16'hb32f;
      6: q = 16'h89c3;
      7: q = 16'hd73f;
    endcase

endmodule
