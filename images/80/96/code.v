module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h6488;
      1: q = 16'hab82;
      2: q = 16'he573;
      3: q = 16'ha79b;
      4: q = 16'hcd78;
      5: q = 16'h8f2c;
      6: q = 16'hbf7f;
      7: q = 16'h07e7;
    endcase

endmodule
