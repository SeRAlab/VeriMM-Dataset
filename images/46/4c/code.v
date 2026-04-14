module top_module(
  input clk, // the clock signal
  input rst, // the reset signal
  input in, // the input signal
  input [N-1:0] filter_taps, // array of filter coefficients
  output reg out // the filtered output signal
);parameter N = 5; // number of taps in the filter

reg [N-1:0] shift_reg; // shift register to store previous input samples

always @(posedge clk) begin
  if (rst) begin
    shift_reg <= {N{1'b0}}; // reset shift register
    out <= 1'b0; // reset output
  end else begin
    shift_reg <= {in, shift_reg[N-1:1]}; // shift input into shift register
    out <= filter_taps * shift_reg; // compute filtered output
  end
end

endmodule