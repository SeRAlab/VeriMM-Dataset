module top_module(
  input in,
  input ref_clk,
  output reg out
);parameter N = 5; // number of delay stages

reg [N-1:0] delay_chain; // create a chain of N flip-flops

always @(posedge ref_clk) begin
  delay_chain <= {in, delay_chain[N-1:1]}; // shift the input signal through the chain
end

assign out = delay_chain[0]; // take the output from the first flip-flop in the chain

endmodule