module top_module(
  input clk,
  output reg [n-1:0] out
);parameter n = 4; // number of flip-flops

reg [n-1:0] state;

always @(posedge clk) begin
  state <= {state[n-2:0], ~state[n-1]};
  out <= state;
end

endmodule