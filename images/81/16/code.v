module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h5e66;
      1: q = 16'h7ea2;
      2: q = 16'h5dcb;
      3: q = 16'h212a;
      4: q = 16'hd5c4;
      5: q = 16'h344c;
      6: q = 16'h2f08;
      7: q = 16'hfa49;
    endcase

endmodule
