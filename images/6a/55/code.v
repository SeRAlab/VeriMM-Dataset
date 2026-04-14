module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h87dd;
      1: q = 16'h2d18;
      2: q = 16'hc292;
      3: q = 16'he14c;
      4: q = 16'h86b2;
      5: q = 16'h76f3;
      6: q = 16'h9ca9;
      7: q = 16'h860a;
    endcase

endmodule
