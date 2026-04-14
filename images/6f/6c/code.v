module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'he49d;
      1: q = 16'h5875;
      2: q = 16'ha410;
      3: q = 16'he709;
      4: q = 16'hfaff;
      5: q = 16'h4a7d;
      6: q = 16'hd465;
      7: q = 16'he197;
    endcase

endmodule
