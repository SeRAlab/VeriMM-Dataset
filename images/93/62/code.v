module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hc603;
      1: q = 16'h2cc5;
      2: q = 16'h14a6;
      3: q = 16'h1ef7;
      4: q = 16'h0535;
      5: q = 16'h7308;
      6: q = 16'h57fe;
      7: q = 16'h3a62;
    endcase

endmodule
