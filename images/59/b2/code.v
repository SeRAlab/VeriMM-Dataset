module top_module(
  input in,
  input [k-1:0] c,
  output reg [2**k-1:0] out
);parameter k = 3; // number of control signals

// Initialize all output signals to 0
integer j;
always @(*) begin
  out = {2**k{1'b0}}; // another way to initialize all output signals to 0
  out[c] = in; // Assign the input to the selected output based on control signals
end

endmodule