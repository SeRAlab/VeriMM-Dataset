module top_module(
  input clk,
  input data,
  output reg locked,
  output reg out
);parameter n = 8; // number of delay elements
parameter k = 4; // gain

reg [n-1:0] delay; // array of delay elements

always @(posedge clk) begin
  delay <= {data, delay[n-1:1]}; // shift in new data and shift out oldest delay
end

reg [n-1:0] delayed_data; // array of delayed data

always @(posedge clk) begin
  delayed_data <= {delayed_data[n-2:0], delay[n-1]}; // shift in new delay and shift out oldest delayed data
end

reg [n-1:0] phase_diff; // array of phase differences

always @(posedge clk) begin
  phase_diff <= {phase_diff[n-2:0], delayed_data[n-1] ^ data}; // calculate phase difference between delayed data and input data
end

reg [n-1:0] control_signal; // array of control signals

always @(posedge clk) begin
  control_signal <= {control_signal[n-2:0], phase_diff[n-1]}; // shift in new phase difference and shift out oldest control signal
end

reg signed [n-1:0] delay_adjustment; // array of delay adjustments, changed to signed type

always @(posedge clk) begin
  if (control_signal[n-1] == 1) begin // if phase difference is positive, increase delay
    delay_adjustment <= {delay_adjustment[n-2:0], k};
  end else begin // if phase difference is negative, decrease delay
    delay_adjustment <= {delay_adjustment[n-2:0], -k};
  end
end

always @(posedge clk) begin
  // Note: Change the way delay is updated to avoid out of order select errors
  if (delay_adjustment[n-1] > 0 && delay[n-1] < n-1) begin // if delay adjustment is positive and delay is not at maximum
    delay <= {delay[n-2:0] + delay_adjustment[n-1], delay[0]}; // Proper order 
  end else if (delay_adjustment[n-1] < 0 && delay[n-1] > 0) begin // if delay adjustment is negative and delay is not at minimum
    delay <= {delay[n-2:0] + delay_adjustment[n-1], delay[0]}; // Proper order 
  end
end

always @(posedge clk) begin
  if (delay[n-1] == n-1) begin // if delay is at maximum, lock is achieved
    locked <= 1;
  end else begin // otherwise, lock is not achieved
    locked <= 0;
  end
end

assign out = delayed_data[n-1]; // output synchronized data

endmodule