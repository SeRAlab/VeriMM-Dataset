module top_module(
  input wire clk,  // Added clock input
  input wire button,
  output reg debounced_signal
);parameter clk_period = 10; // period of the clock signal in nanoseconds
parameter debounce_time = 50; // debounce time in nanoseconds

reg button_state;
reg [3:0] debounce_counter;

always @(posedge clk) begin
  if (button != button_state) begin
    debounce_counter <= debounce_time / clk_period; // Reset the debounce counter
  end else if (debounce_counter > 0) begin
    debounce_counter <= debounce_counter - 1; // Count down the debounce counter
  end else begin
    button_state <= button; // Update button state after debouncing
  end
end

always @(posedge clk) begin
  if (debounce_counter == 0) begin
    debounced_signal <= button_state; // Update debounced signal
  end
end

endmodule