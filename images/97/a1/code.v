module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h6863;
      1: q = 16'h177b;
      2: q = 16'hfc64;
      3: q = 16'hcd45;
      4: q = 16'h5733;
      5: q = 16'h0ca6;
      6: q = 16'h9ca1;
      7: q = 16'h476b;
    endcase

endmodule
