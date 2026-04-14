module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'he445;
      1: q = 16'h9319;
      2: q = 16'h6eda;
      3: q = 16'h370f;
      4: q = 16'h3a18;
      5: q = 16'h464e;
      6: q = 16'h05e9;
      7: q = 16'h9933;
    endcase

endmodule
