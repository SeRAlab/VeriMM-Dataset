module top_module(
  input [n-1:0] sym,
  input [n-1:0] prob,
  output reg [31:0] encoded_value,
  input [31:0] encoded_value_in,
  output reg [n-1:0] decoded_sym
);parameter n = 8; // number of input symbols/probabilities

//Compute CDF for input symbols
reg [n-1:0] cdf;
reg [n-1:0] temp_cdf;
integer i, j;

always @* begin
  cdf[0] = 0;
  for (i = 1; i < n; i = i + 1) begin
    temp_cdf[i] = cdf[i-1] + prob[i-1];
    cdf[i] = temp_cdf[i];
  end
end

//Encode input symbols
reg [31:0] low;
reg [31:0] high;
reg [31:0] range;
reg [31:0] temp;

always @* begin
  low = 0;
  high = (1 << 31) - 1;
  range = high - low + 1;
  for (i = 0; i < n; i = i + 1) begin
    temp = range * cdf[i];
    high = low + temp/prob[i] - 1;
    low = low + (temp + range * cdf[i+1] - 1)/prob[i];
    range = high - low + 1;
  end
  encoded_value = low;
end

//Decode encoded value
reg [31:0] decoded_value;
reg [31:0] temp_range;
reg [n-1:0] temp_sym;

always @* begin
  decoded_value = encoded_value_in;
  temp_range = high - low + 1;
  for (i = 0; i < n; i = i + 1) begin
    temp_sym[i] = 0;
    for (j = 0; j < n; j = j + 1) begin
      if (temp_cdf[j] <= (decoded_value - low + 1)*prob[i]/temp_range) begin
        temp_sym[i] = j;
      end
    end
    decoded_sym[i] = temp_sym[i];
    temp_range = temp_range * prob[temp_sym[i]];
    decoded_value = decoded_value - low + 1 - temp_range * temp_cdf[temp_sym[i]];
    low = low + temp_range * temp_cdf[temp_sym[i]];
    high = low + temp_range * prob[temp_sym[i]] - 1;
  end
end

endmodule