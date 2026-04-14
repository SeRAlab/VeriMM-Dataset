module top_module(
  input clk,
  output [n-1:0] out
);parameter n = 8; // number of output signals

reg [n-1:0] counter;

always @(posedge clk) begin
  counter <= {counter[n-2:0], counter[n-1]};
end

assign out = counter;

endmodule