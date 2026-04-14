module barrel_shifter (
  input [31:0] data,
  input [4:0] shift_amt,
  input dir,
  output reg [31:0] out
);

  always @(*) begin
    if (dir)
      out = data << shift_amt;
    else
      out = data >> shift_amt;
  end

endmodule