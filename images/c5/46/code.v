module reset_synchronizer (
  input rst,
  input clk,
  output reg rst_sync
);

parameter DELAY = 2; // number of delay elements

always @(posedge clk) begin
  rst_sync <= #DELAY (rst);
end

endmodule