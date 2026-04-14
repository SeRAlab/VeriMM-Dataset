module top_module(
  input async_in,
  input clk_in,
  output reg sync_out
);reg async_sync;
  reg async_sync_prev;
  
  always @(posedge clk_in) begin
    async_sync_prev <= async_sync;
    async_sync <= async_in;
  end
  
  always @(posedge clk_in) begin
    if (clk_in) begin
      sync_out <= async_sync;
    end else begin
      sync_out <= async_sync_prev;
    end
  end
  
endmodule