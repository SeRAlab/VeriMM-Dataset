module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'ha9f5;
      1: q = 16'hf36e;
      2: q = 16'ha4f4;
      3: q = 16'h1480;
      4: q = 16'h1d42;
      5: q = 16'hb9fe;
      6: q = 16'h3754;
      7: q = 16'h15f5;
    endcase

endmodule
