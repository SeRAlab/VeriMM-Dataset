module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h70f3;
      1: q = 16'h5dc0;
      2: q = 16'h0c0b;
      3: q = 16'hba09;
      4: q = 16'h34ed;
      5: q = 16'h950a;
      6: q = 16'hdca7;
      7: q = 16'h0d75;
    endcase

endmodule
