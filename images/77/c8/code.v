module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h50e8;
      1: q = 16'h783e;
      2: q = 16'h09ab;
      3: q = 16'h58cf;
      4: q = 16'h185c;
      5: q = 16'h6f0d;
      6: q = 16'h6d7e;
      7: q = 16'hb972;
    endcase

endmodule
