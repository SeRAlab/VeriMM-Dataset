module top_module(
  input clk,         // Added clock input
  input in,
  output reg out     // Changed output to reg to allow assignment in always block
);parameter n = 10; // number of clock cycles to wait before outputting a filtered signal
parameter k = 3;  // number of consecutive clock cycles that the input signal must be high before it is considered a valid signal

reg [n-1:0] shift_reg; // shift register of length n
reg [2:0] counter; // counter to count the number of consecutive high input signals

always @(posedge clk) begin
  shift_reg <= {shift_reg[n-2:0], in}; // shift in the input signal
  
  if (shift_reg[0] == 1) begin // if the input signal is high
    if (counter == k-1) begin // if the input signal has been high for k consecutive clock cycles
      out <= 1; // output a filtered signal
    end else begin
      counter <= counter + 1; // increment the counter
      out <= 0; // output an unfiltered signal
    end
  end else begin
    counter <= 0; // reset the counter
    out <= 0; // output an unfiltered signal
  end
end

endmodule