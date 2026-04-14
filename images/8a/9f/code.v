module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h9dfb;
      1: q = 16'hdf23;
      2: q = 16'hbfc5;
      3: q = 16'h71cc;
      4: q = 16'hb8d6;
      5: q = 16'h43a2;
      6: q = 16'hb232;
      7: q = 16'h9fbc;
    endcase

endmodule
