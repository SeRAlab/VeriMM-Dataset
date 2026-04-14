module top_module(
  input wire in,
  input wire clk, // Added clk input
  output wire out
);parameter n = 4; // number of delay stages
parameter d = 10; // delay between adjacent stages (in nanoseconds)

reg [n-1:0] delay_line_reg; // register array to store delayed signals

always @(posedge clk) begin
  delay_line_reg <= {in, delay_line_reg[n-2:0]}; // shift input signal into delay line
end

assign out = delay_line_reg[n-1]; // output signal from last delay stage

endmodule