module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hf776;
      1: q = 16'h9094;
      2: q = 16'h1f96;
      3: q = 16'h1d66;
      4: q = 16'h65f6;
      5: q = 16'h215f;
      6: q = 16'h141c;
      7: q = 16'h9408;
    endcase

endmodule
