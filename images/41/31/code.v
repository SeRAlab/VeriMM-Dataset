module top_module(
  input clk,
  input [n-1:0] in,
  output [n-1:0] out_I,
  output [n-1:0] out_Q
);parameter n = 8; // number of bits used to represent the input signal

reg [n-1:0] delayed_in;
reg [n-1:0] inverted_in;

// Delay function
always @ (posedge clk) begin
  delayed_in <= in;
end

// Phase shift and inversion function
always @ (posedge clk) begin
  inverted_in <= ~in;
end

// In-phase and quadrature-phase components
assign out_I = in + delayed_in;
assign out_Q = inverted_in + delayed_in;

endmodule