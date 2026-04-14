module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h06dc;
      1: q = 16'he991;
      2: q = 16'h8aa0;
      3: q = 16'h599a;
      4: q = 16'hab28;
      5: q = 16'hd99e;
      6: q = 16'hb60a;
      7: q = 16'hc653;
    endcase

endmodule
