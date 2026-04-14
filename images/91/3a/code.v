module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h6103;
      1: q = 16'h2f5b;
      2: q = 16'hacfa;
      3: q = 16'hebf3;
      4: q = 16'h650f;
      5: q = 16'h3136;
      6: q = 16'hd3b9;
      7: q = 16'h0340;
    endcase

endmodule
