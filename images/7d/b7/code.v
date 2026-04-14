module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h988e;
      1: q = 16'h4604;
      2: q = 16'ha2c1;
      3: q = 16'h058e;
      4: q = 16'h0fb3;
      5: q = 16'h81fe;
      6: q = 16'h395c;
      7: q = 16'h6da2;
    endcase

endmodule
