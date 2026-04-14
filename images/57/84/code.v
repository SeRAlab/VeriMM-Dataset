module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hf68d;
      1: q = 16'hfd1f;
      2: q = 16'hcdd8;
      3: q = 16'he3a5;
      4: q = 16'h8da3;
      5: q = 16'h1c4d;
      6: q = 16'h09bf;
      7: q = 16'h4e1f;
    endcase

endmodule
