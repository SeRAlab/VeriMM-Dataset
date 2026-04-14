module top_module(
  input clk,
  output reg [n-1:0] out
);parameter n = 4; // number of output signals

reg [n-1:0] counter;

always @(posedge clk) begin
  counter <= {counter[n-2:0], counter[n-1]};
end

assign out = counter;

endmodule