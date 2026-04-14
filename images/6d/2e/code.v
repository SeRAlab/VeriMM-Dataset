module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hbdaa;
      1: q = 16'h0fbb;
      2: q = 16'hdec6;
      3: q = 16'h7445;
      4: q = 16'h6ee6;
      5: q = 16'h062e;
      6: q = 16'h6eaa;
      7: q = 16'h4b32;
    endcase

endmodule
