module top_module(
  input [7:0] in,
  input [2:0] shift_amt,
  input dir,
  output [7:0] out,
  output flag
);reg [7:0] shifted; // register to hold the shifted value
  reg carry; // register to hold the carry flag

  always @(*) begin
    if (dir == 0) begin // left shift
      shifted = in << shift_amt;
      carry = shifted[7]; // check if the leftmost bit is shifted out
    end else begin // right shift
      shifted = in >> shift_amt;
      carry = shifted[0]; // check if the rightmost bit is shifted out
    end
  end

  assign out = shifted;
  assign flag = carry;

endmodule