module top_module(
  input clk,                 // Added the missing clock input
  input [n-1:0] in,
  output reg [n-1:0] out    // Changed output declaration to reg to allow assignment in always block
);parameter n = 4; // number of input and output signals
parameter delay = 2; // initial delay value

reg [n-1:0] delayed_in; // delayed input signals

// Delay element
always @(posedge clk) begin
  delayed_in <= {in[n-1: n-delay], in[n-delay-1:0]}; // Corrected part select order
end

// Feedback loop
always @(posedge clk) begin
  out <= delayed_in;
end

endmodule