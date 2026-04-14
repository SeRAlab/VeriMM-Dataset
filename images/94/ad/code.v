module top_module(
  input clk,
  input we,
  input re,
  input [addr_bits-1:0] addr,
  input [m-1:0] wd,
  output reg [m-1:0] rd
);parameter n = 8; // number of words
parameter m = 16; // number of bits in each word

// Calculate the number of bits needed to address n words
localparam addr_bits = $clog2(n);

reg [m-1:0] cache[n-1:0]; // Array to store the words

// Write data to the selected word
always @(posedge clk) begin
  if (we) begin
    cache[addr] <= wd;
  end
end

// Read data from the selected word
always @(*) begin
  if (re) begin
    rd = cache[addr];
  end else begin
    rd = 0;
  end
end

endmodule