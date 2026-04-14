module top_module(
  input [n-1:0] data_in,
  input [log2n-1:0] shift_amt,
  input [1:0] shift_type,
  output [n-1:0] data_out
);parameter n = 8; // number of bits in data_in
parameter log2n = 3; // log2(n), used for shift_amt width

reg [n-1:0] shifted_data; // temporary variable for storing shifted data

// Left shift operation
always @(*) begin
  case(shift_type)
    2'b00: shifted_data = data_in << shift_amt; // logical left shift
    2'b01: shifted_data = data_in >>> shift_amt; // arithmetic right shift
    2'b10: shifted_data = data_in >> shift_amt; // logical right shift
    default: shifted_data = data_in; // no shift
  endcase
end

// Output the shifted data
assign data_out = shifted_data;

endmodule