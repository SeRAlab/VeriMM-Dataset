module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h32a1;
      1: q = 16'hcdc1;
      2: q = 16'h81e1;
      3: q = 16'h2a52;
      4: q = 16'ha5c4;
      5: q = 16'h788c;
      6: q = 16'h5dd8;
      7: q = 16'he48f;
    endcase

endmodule
