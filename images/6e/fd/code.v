module top_module(
  input [n-1:0] rx_in,
  input [k-1:0] known_in,
  output reg [k-1:0] decoded_out // Changed to 'reg' to make it a valid l-value
);parameter n = 8; // number of received data bits
parameter k = 4; // number of known data bits

// State transition and output tables
reg [k-1:0] state_transition [0:(1<<k)-1];
reg [n-1:0] output_table [0:(1<<k)-1];

integer i, j, state;

// Generate state transition and output tables
initial begin
  for (i = 0; i < (1<<k); i = i + 1) begin
    state = i >> 1;
    state_transition[i] = state;
    output_table[i] = (i & 1) ^ (state & 1);
  end
end

// Viterbi algorithm
reg [k-1:0] decoded_state;
reg [31:0] likelihood [0:(1<<k)-1];
reg [31:0] min_likelihood;
reg [31:0] temp_likelihood;

always @(*) begin
  // Initialize likelihoods
  for (i = 0; i < (1<<k); i = i + 1) begin
    likelihood[i] = 0;
  end

  // Calculate likelihoods for each state
  for (i = 0; i < n; i = i + 1) begin
    for (j = 0; j < (1<<k); j = j + 1) begin
      temp_likelihood = (rx_in[i] == output_table[j]) ? 0 : 1;
      likelihood[state_transition[j]] = likelihood[state_transition[j]] + temp_likelihood;
    end
  end

  // Find the state with the minimum likelihood
  min_likelihood = likelihood[0];
  decoded_state = 0;
  for (i = 1; i < (1<<k); i = i + 1) begin
    if (likelihood[i] < min_likelihood) begin
      min_likelihood = likelihood[i];
      decoded_state = i;
    end
  end

  // Generate decoded output
  for (i = 0; i < k; i = i + 1) begin
    decoded_out[i] = decoded_state[i];
  end
end

endmodule