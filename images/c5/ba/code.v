module sl3(input  [31:0] a,
           output [31:0] y);

  // shift left by 3
  assign y = {a[28:0], 3'b000};
endmodule