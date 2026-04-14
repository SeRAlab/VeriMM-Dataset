module top_module(clk, reset, sync_reset);input clk, reset;
output sync_reset;
reg sync_reset, tmp_reset;

always @(posedge clk)
begin
	tmp_reset = reset;
end

always @(posedge clk)
begin
	sync_reset = tmp_reset;
end



endmodule