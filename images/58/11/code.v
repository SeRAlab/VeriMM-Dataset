module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'ha519;
      1: q = 16'hd16b;
      2: q = 16'h6804;
      3: q = 16'h2b9c;
      4: q = 16'hf0ba;
      5: q = 16'hcb7b;
      6: q = 16'h685b;
      7: q = 16'hf7b9;
    endcase

endmodule
