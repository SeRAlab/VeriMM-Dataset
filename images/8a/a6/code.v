module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'he0fb;
      1: q = 16'h9e40;
      2: q = 16'h8ee6;
      3: q = 16'h0e4a;
      4: q = 16'h34d1;
      5: q = 16'hde19;
      6: q = 16'h0466;
      7: q = 16'h921f;
    endcase

endmodule
