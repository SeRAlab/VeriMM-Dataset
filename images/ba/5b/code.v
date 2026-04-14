module top_module(
  input [n-1:0] in,
  input [n-1:0] echo,
  input clk, // Added clk input
  output reg [n-1:0] out // Changed output to reg type for drive assignment
);parameter n = 4; // number of input and output signals
parameter delay = 2; // Changed delay to a positive value less than n

reg [n-1:0] delayed_echo; // delayed echo signal

always @(posedge clk) begin
  delayed_echo <= {echo[n-delay-1:0], {delay{1'b0}}}; // Corrected the delay signal assignment
  out <= in - delayed_echo; // Assigning the output within the always block
end

endmodule