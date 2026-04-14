module counter_3bit_sync_reset (
  input clk,
  input reset,
  output reg [2:0] count
);

always @(posedge clk) begin
  count <= (reset) ? 3'b0 : count + 1;
end

endmodule
