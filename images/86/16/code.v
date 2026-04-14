module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h75e6;
      1: q = 16'h2a00;
      2: q = 16'h9cd6;
      3: q = 16'h1da0;
      4: q = 16'ha767;
      5: q = 16'h5438;
      6: q = 16'h396f;
      7: q = 16'he681;
    endcase

endmodule
