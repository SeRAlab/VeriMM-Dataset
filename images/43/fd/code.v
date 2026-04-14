module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'haf10;
      1: q = 16'h7056;
      2: q = 16'h184a;
      3: q = 16'hde72;
      4: q = 16'hd3d8;
      5: q = 16'h035b;
      6: q = 16'hc7b1;
      7: q = 16'h1c48;
    endcase

endmodule
