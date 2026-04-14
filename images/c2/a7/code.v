module comb_op
(
  input [3:0] in,
  output reg [3:0] out
);

  always @(*)
  begin
    if (in >= 0 && in <= 7) // Range 0 to 7
      out = in << 1;
    else if (in >= 8 && in <= 15) // Range 8 to 15
      out = in >> 1;
    else // Outside range 0 to 15
      out = 0;
  end

endmodule