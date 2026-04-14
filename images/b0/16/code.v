module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h6823;
      1: q = 16'hb01f;
      2: q = 16'hc267;
      3: q = 16'h95f1;
      4: q = 16'h4341;
      5: q = 16'h5e48;
      6: q = 16'h7ba0;
      7: q = 16'hf6ce;
    endcase

endmodule
