module top_module(
  input [31:0] in,
  input [4:0] shift_amt,
  input [1:0] shift_type,
  output [31:0] out
);reg [31:0] shifted_value;

  always @(*) begin
    case (shift_type)
      2'b00: shifted_value = in << shift_amt; // left shift
      2'b01: shifted_value = in >>> shift_amt; // arithmetic right shift
      2'b10: shifted_value = in >> shift_amt; // logical right shift
      default: shifted_value = in; // no shift
    endcase
  end

  assign out = shifted_value;

endmodule