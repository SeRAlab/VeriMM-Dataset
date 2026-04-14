module top_module(
  input clk,
  output [n-1:0] out
);parameter n = 4; // number of output signals

reg [n-1:0] state;
wire [n-1:0] next_state;

assign out = state;

always @ (posedge clk) begin
  state <= next_state;
end

assign next_state[0] = state[n-1];
generate
  genvar i;
  for (i = 1; i < n; i = i + 1) begin : loop
    assign next_state[i] = state[i-1] ^ state[n-1];
  end
endgenerate

endmodule