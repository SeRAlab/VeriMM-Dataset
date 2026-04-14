module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hc6a5;
      1: q = 16'h8d25;
      2: q = 16'h1938;
      3: q = 16'hb69b;
      4: q = 16'h4a95;
      5: q = 16'hc8a1;
      6: q = 16'h69e9;
      7: q = 16'hdc0d;
    endcase

endmodule
