module top_module(
  input [n-1:0] received_signal,
  input [k-1:0] channel_state,
  output reg [m-1:0] decoded_message // changed to reg to assign values inside always block
);parameter n = 10; // number of received signal bits
parameter k = 3; // number of channel state bits
parameter m = 8; // number of bits in the decoded message

// Trellis structure
reg [k-1:0] trellis [(1<<k)-1:0];
integer i, j, state;

// Initialization
initial begin
  for (i = 0; i < (1<<k); i = i + 1) begin
    trellis[i] = i[k-1:0];
  end
end

// Viterbi algorithm
reg [m-1:0] path_metric [(1<<k)-1:0];
reg [m-1:0] temp_path_metric [(1<<k)-1:0];
reg [k-1:0] best_path [(1<<k)-1:0]; // best_path should have the same width as channel_state

integer min_metric, best_state;

// Sensitivity on received_signal
always @(received_signal or channel_state) begin
  // Initialize path metrics
  for (i = 0; i < (1<<k); i = i + 1) begin
    path_metric[i] = 0;
  end

  // Iterate through received signal bits
  for (i = 0; i < n; i = i + 1) begin
    // Update path metrics
    for (state = 0; state < (1<<k); state = state + 1) begin
      temp_path_metric[state] = path_metric[state] + (received_signal[i] ^ trellis[state]);
    end

    // Find the best path
    for (state = 0; state < (1<<k); state = state + 1) begin
      min_metric = 32'h7FFFFFFF;
      best_state = 0;
      for (j = 0; j < (1<<k); j = j + 1) begin
        if (temp_path_metric[j] < min_metric) begin
          min_metric = temp_path_metric[j];
          best_state = j;
        end
      end
      path_metric[state] = min_metric;
      best_path[state] = best_state;
    end
  end

  // Trace back to find the decoded message
  best_state = 0;
  for (i = m - 1; i >= 0; i = i - 1) begin
    decoded_message[i] = best_path[best_state][0]; // changed to best_state indexing for correct access
    best_state = best_path[best_state];
  end
end

endmodule