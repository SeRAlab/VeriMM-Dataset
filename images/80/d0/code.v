module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h19e0;
      1: q = 16'hcdec;
      2: q = 16'h27ae;
      3: q = 16'h39b0;
      4: q = 16'h9b8f;
      5: q = 16'h4bf7;
      6: q = 16'hbdaf;
      7: q = 16'h1933;
    endcase

endmodule
