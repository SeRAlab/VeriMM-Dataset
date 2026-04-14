module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h3df8;
      1: q = 16'h4f13;
      2: q = 16'h1095;
      3: q = 16'h2f5c;
      4: q = 16'ha5b5;
      5: q = 16'h9529;
      6: q = 16'hd6f2;
      7: q = 16'h594f;
    endcase

endmodule
