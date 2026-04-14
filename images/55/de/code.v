module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h3d0b;
      1: q = 16'h1887;
      2: q = 16'h6ede;
      3: q = 16'h35ab;
      4: q = 16'h0fdc;
      5: q = 16'h9a80;
      6: q = 16'h2383;
      7: q = 16'h9ba5;
    endcase

endmodule
