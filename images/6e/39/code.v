module top_module(
  input [n*w-1:0] search,
  output reg [m*w-1:0] match // Change output to reg type
);parameter n = 4; // number of search signals
parameter m = 2; // number of match signals
parameter w = 8; // width of each search/match signal in bits
parameter s = 16; // number of memory cells

reg [w-1:0] search_pattern [0:s-1]; // array of search patterns
reg [w-1:0] match_pattern [0:s-1]; // array of match patterns

integer i, j; // loop variables

always @(*) begin
  match = 0; // Initialize match to zero
  for (i = 0; i < s; i = i + 1) begin
    if (search == search_pattern[i]) begin
      for (j = 0; j < m; j = j + 1) begin
        match[j*w +: w] = match_pattern[i][j*w +: w];
      end
    end
  end
end

endmodule