module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h7955;
      1: q = 16'ha72e;
      2: q = 16'h02d9;
      3: q = 16'hcbca;
      4: q = 16'h0125;
      5: q = 16'hc396;
      6: q = 16'hbce4;
      7: q = 16'h620d;
    endcase

endmodule
