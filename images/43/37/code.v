module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h6f4d;
      1: q = 16'h8cce;
      2: q = 16'h562a;
      3: q = 16'hc1d1;
      4: q = 16'h6dcc;
      5: q = 16'hbe5f;
      6: q = 16'hb370;
      7: q = 16'hf21a;
    endcase

endmodule
