module bin_to_gray (
  input [3:0] binary,
  output [3:0] gray);
  
assign gray = binary ^ (binary >> 1);
endmodule