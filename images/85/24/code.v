module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h4643;
      1: q = 16'h6a75;
      2: q = 16'he76a;
      3: q = 16'hf294;
      4: q = 16'ha614;
      5: q = 16'hee29;
      6: q = 16'h9a4a;
      7: q = 16'h3be3;
    endcase

endmodule
