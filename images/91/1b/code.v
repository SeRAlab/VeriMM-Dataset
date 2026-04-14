module top_module(
  input [n-1:0] in,
  input [1:0] ctrl,
  input [n-1:0] shift_amt,
  output reg [n-1:0] out
);parameter n = 8; // number of bits in the input and output signals

// Left shift operation
always @(*) begin
  case (ctrl)
    2'b00: out = in << shift_amt;  // Logical left shift
    2'b01: out = in >> shift_amt;  // Logical right shift
    2'b10: out = $signed(in) >>> shift_amt; // Arithmetic right shift
    default: out = in; // Default case
  endcase
end

endmodule