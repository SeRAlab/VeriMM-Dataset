module top_module(
  input [n-1:0] d,
  input parity_mode,
  input parity_in,
  input clk, // Add clk input
  output p,
  output f
);parameter n = 8; // number of data bits

reg [n-1:0] d_reg;
reg p_reg;
wire [n-1:0] ones_count;
wire parity_check;

// Count the number of ones in the data register
assign ones_count = d_reg; // Corrected to directly assign d_reg

// Check parity based on the parity_mode
assign parity_check = (parity_mode == 1'b0) ? (ones_count % 2 == 0) : (ones_count % 2 == 1);

always @(posedge clk) begin
  d_reg <= d;
  p_reg <= parity_check;
end

assign p = p_reg;
assign f = (parity_check == parity_in) ? 1'b1 : 1'b0;

endmodule