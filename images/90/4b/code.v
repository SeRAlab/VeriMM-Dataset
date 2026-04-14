module top_module(dac_clk, dac_data);input dac_clk;
output [9:0] dac_data;
reg [9:0] dac_data;


reg [15:0] cnt;

always @(posedge dac_clk)
begin
 cnt <= cnt + 16'h1;

dac_data = cnt[9:0];

end
endmodule