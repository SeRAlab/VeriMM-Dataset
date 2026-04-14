module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h4c03;
      1: q = 16'h7c60;
      2: q = 16'h8d5b;
      3: q = 16'h4d70;
      4: q = 16'h1ce6;
      5: q = 16'h71c2;
      6: q = 16'ha67d;
      7: q = 16'he3bf;
    endcase

endmodule
