module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'he56f;
      1: q = 16'hf214;
      2: q = 16'h4950;
      3: q = 16'had2c;
      4: q = 16'hd38e;
      5: q = 16'hfdaa;
      6: q = 16'h129c;
      7: q = 16'hee84;
    endcase

endmodule
