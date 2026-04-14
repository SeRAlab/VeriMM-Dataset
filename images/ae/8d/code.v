module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h23d8;
      1: q = 16'h5259;
      2: q = 16'hbfd7;
      3: q = 16'h64bd;
      4: q = 16'h1ac8;
      5: q = 16'ha2c4;
      6: q = 16'h6482;
      7: q = 16'hfecb;
    endcase

endmodule
