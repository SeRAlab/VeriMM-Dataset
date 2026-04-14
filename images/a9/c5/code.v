module top_module(
  input analog_in,
  input clk,
  input rst,
  output reg [bits-1:0] digital_out
);parameter bits = 8; // number of bits in the output digital signal

reg [bits-1:0] digital_value; // digital value of the analog input signal
reg [bits-1:0] sample_value; // sampled value of the analog input signal

always @(posedge clk) begin
  if (rst) begin // reset to a known state
    digital_value <= 0;
    sample_value <= 0;
  end else begin
    sample_value <= analog_in; // sample the analog input signal
    digital_value <= sample_value >> (16-bits); // convert the sampled value to a digital value
    digital_out <= digital_value; // update the output signal
  end
end

endmodule