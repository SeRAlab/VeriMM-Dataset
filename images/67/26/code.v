module top_module(
  input [n-1:0] symbol_in,
  input [n-1:0] prob_in,
  input end_flag,
  output reg [31:0] encoded_out,
  input [31:0] encoded_in,
  output reg [n-1:0] symbol_out
);parameter n = 8; // number of symbols
parameter frac_bits = 16; // number of fractional bits for fixed-point representation

reg [31:0] cum_prob [0:n-1]; // cumulative probabilities
reg [31:0] low, high, range;
integer i;

// Calculate cumulative probabilities
always @ (prob_in) begin
  cum_prob[0] <= prob_in[0];
  for (i = 1; i < n; i = i + 1) begin
    cum_prob[i] <= cum_prob[i-1] + prob_in[i];
  end
end

// AN encoder
always @ (symbol_in or end_flag) begin
  if (!end_flag) begin
    low <= 0;
    high <= (1 << frac_bits) - 1;
    for (i = 0; i < n; i = i + 1) begin
      if (symbol_in == i) begin
        range <= high - low + 1;
        high <= low + ((range * cum_prob[i+1]) >> frac_bits) - 1;
        low <= low + ((range * cum_prob[i]) >> frac_bits);
      end
    end
  end
  encoded_out <= low;
end

// AN decoder
always @ (encoded_in or end_flag) begin
  if (!end_flag) begin
    for (i = 0; i < n; i = i + 1) begin
      if ((encoded_in >= (cum_prob[i] << (32 - frac_bits))) && (encoded_in < (cum_prob[i+1] << (32 - frac_bits)))) begin
        symbol_out <= i;
      end
    end
  end
end

endmodule