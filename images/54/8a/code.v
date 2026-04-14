module top_module(
  input clk,
  output reg [n-1:0] out
);parameter n = 4; // number of output signals
parameter m = 4; // number of flip-flops in the ring

reg [m-1:0] flip_flops;

always @(posedge clk) begin
  flip_flops <= {flip_flops[m-2:0], flip_flops[m-1]};
end

assign out = flip_flops[n-1:0];

endmodule