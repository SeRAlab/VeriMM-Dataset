module top_module(
  input clk,
  output reg [n-1:0] out
);parameter n = 4; // number of output signals

reg [n-1:0] state;

always @(posedge clk) begin
  state <= {state[n-2:0], state[n-1]};
end

assign out = state;

endmodule