module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h232c;
      1: q = 16'h7668;
      2: q = 16'h5e3e;
      3: q = 16'h3447;
      4: q = 16'h984b;
      5: q = 16'h8de2;
      6: q = 16'h23f5;
      7: q = 16'h1dc8;
    endcase

endmodule
