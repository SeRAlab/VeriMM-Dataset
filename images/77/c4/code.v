module top_module(
  input signal_in,
  input clock,
  output reg rising_edge,
  output reg falling_edge
);reg prev_signal_in;
  
  always @(posedge clock) begin
    // Detect rising edge
    if (signal_in && !prev_signal_in) begin
      rising_edge <= 1;
    end else begin
      rising_edge <= 0;
    end
    
    // Detect falling edge
    if (!signal_in && prev_signal_in) begin
      falling_edge <= 1;
    end else begin
      falling_edge <= 0;
    end
    
    // Store the previous state
    prev_signal_in <= signal_in;
  end
  
endmodule