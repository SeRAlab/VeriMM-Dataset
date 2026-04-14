module top_module(
  input [n-1:0] in,
  input [1:0] sel,
  input [4:0] shift_amt,
  output [m-1:0] out
);parameter n = 8; // number of input signals
parameter m = 8; // number of output signals

reg [n-1:0] shifted_in;

always @(*) begin
  case (sel)
    2'b00: shifted_in = in << shift_amt; // left shift
    2'b01: shifted_in = in >> shift_amt; // right shift
    2'b10: shifted_in = $signed(in) >>> shift_amt; // arithmetic shift
    default: shifted_in = in;
  endcase
end

assign out = shifted_in[m-1 : 0];

endmodule