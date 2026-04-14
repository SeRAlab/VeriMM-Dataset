module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out
);parameter n = 16; // number of received bits
parameter m = 8; // number of decoded bits
parameter k = 3; // number of bits in each convolutional code
parameter p = 8; // number of states in the Viterbi decoder

integer i, j, t;
reg [k-1:0] state;
reg [p-1:0] metric;
reg [p-1:0] min_metric;
reg [p-1:0] min_state;

// State transition function
function [k-1:0] next_state;
  input [k-1:0] current_state;
  input in_bit;
  begin
    next_state = {current_state[k-2:0], in_bit};
  end
endfunction

// Output function
function [n-1:0] output_bits;
  input [k-1:0] current_state;
  begin
    output_bits = current_state[k-1] ^ current_state[k-2];
  end
endfunction

// Metric computation
always @(in) begin
  for (i = 0; i < p; i = i + 1) begin
    metric[i] = 0;
    for (j = 0; j < n; j = j + 1) begin
      if (in[j] != output_bits(state)) begin
        metric[i] = metric[i] + 1;
      end
      state = next_state(state, in[j]);
    end
  end
end

// State selection
always @(metric) begin
  min_metric = metric[0];
  min_state = 0;
  for (i = 1; i < p; i = i + 1) begin
    if (metric[i] < min_metric) begin
      min_metric = metric[i];
      min_state = i;
    end
  end
end

// Decoded bits computation
always @(min_state) begin
  state = min_state;
  for (t = 0; t < m; t = t + 1) begin
    out[t] = state[k-1];
    state = next_state(state, in[t]);
  end
end

endmodule