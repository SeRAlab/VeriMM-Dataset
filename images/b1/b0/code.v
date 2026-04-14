module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  input clk, // Added clk input
  output [2*n-1:0] c // Changed size of output to accommodate the product
);parameter n = 8; // width of input signals

wire [2*n-1:0] prod;
wire [2*n-1:0] sum;
reg [2*n-1:0] c_reg; // Changed size of reg to accommodate product

// Stage 1: Generate partial products
genvar i, j;
generate
  for (i = 0; i < n; i = i + 1) begin
    for (j = 0; j < n; j = j + 1) begin
      assign prod[i+j] = a[i] & b[j];
    end
  end
endgenerate

// Stage 2: Generate partial sums
genvar k;
generate
  for (k = 0; k < 2*n; k = k + 1) begin // Adjusted to include full range
    assign sum[k] = (k < n) ? prod[k] : 1'b0; // Ensure proper initialization
    for (i = 0; i < k && i < n; i = i + 1) begin
      assign sum[k] = sum[k] + (k-i < n ? prod[i+n+k] : 1'b0); // Ensure proper indexing
    end
  end
endgenerate

// Stage 3: Generate final sum
always @ (posedge clk) begin
  c_reg <= sum[n-1:0]; // Change c_reg assignment to fit required width
end

assign c = c_reg;

endmodule