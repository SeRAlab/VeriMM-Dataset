module dwt(input [3:0] x, output [3:0] y);
  wire [1:0] low_pass, high_pass;

  assign low_pass = (x[3:2] + x[1:0]) >> 1;  // Average of pairs
  assign high_pass = (x[3:2] - x[1:0]);      // Difference of pairs

  assign y = {high_pass, low_pass};           // Concatenate high-pass and low-pass
endmodule