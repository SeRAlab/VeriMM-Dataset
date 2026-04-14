module top_module(
  input [n-1:0] in,
  input reset,
  input clk,
  output [k-1:0] out,
  output error
);parameter n = 8; // number of input bits
parameter k = 4; // number of bits in checksum
parameter g = 4'h3; // generator polynomial

reg [n+k-1:0] reg_in;
reg [k-1:0] reg_out;
reg [n+k-1:0] reg_dividend;
reg [k:0] reg_divisor;

wire [n+k-1:0] remainder;

assign remainder = reg_dividend ^ (reg_divisor << (n+k-1));

always @(posedge clk) begin
  if (reset) begin
    reg_in <= 0;
    reg_out <= 0;
    reg_dividend <= 0;
    reg_divisor <= g;
  end else begin
    reg_dividend <= {reg_in[n-1:0], reg_out}; // Changed the order for correct concatenation
    reg_out <= remainder[k-1:0]; // Corrected the part select order
    reg_in <= in; // Store the input
    reg_divisor <= {1'b1, reg_out}; // Keep reg_divisor with new reg_out
  end
end

assign out = reg_out;
assign error = (remainder[n+k-1:k] == 0) ? 1'b0 : 1'b1;

endmodule