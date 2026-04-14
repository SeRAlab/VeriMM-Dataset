module top_module(
  input rst_n,
  input clk,
  output reg rst
);parameter reset_period = 10; // reset period in clock cycles

reg rst_sync;
reg [3:0] rst_counter;

always @(posedge clk) begin
  if (rst_n == 1'b0) begin
    rst_sync <= 1'b0;
    rst_counter <= 4'b0000;
  end else begin
    rst_sync <= rst_n;
    if (rst_counter < reset_period) begin
      rst_counter <= rst_counter + 1;
    end
  end
end

assign rst = rst_sync & (rst_counter < reset_period);

endmodule