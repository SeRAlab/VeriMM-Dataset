module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h2b11;
      1: q = 16'h9eb9;
      2: q = 16'hcf36;
      3: q = 16'h3ff6;
      4: q = 16'h366e;
      5: q = 16'h8652;
      6: q = 16'h0cfc;
      7: q = 16'h6e3c;
    endcase

endmodule
