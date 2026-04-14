module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hc1fc;
      1: q = 16'hbefc;
      2: q = 16'hf15a;
      3: q = 16'h71e6;
      4: q = 16'h6b35;
      5: q = 16'h0f93;
      6: q = 16'hd003;
      7: q = 16'h037b;
    endcase

endmodule
