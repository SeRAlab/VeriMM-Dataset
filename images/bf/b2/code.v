module watchdog # (
		parameter CNT_WIDTH = 0
		)(
		input rst,
		input clk,
		input wdt_clk,
		input wdt_rst_in,
		output reg wdt_rst_out);
reg [CNT_WIDTH:0]wdt_cnt;
reg reset;
reg reset_n;
reg wdt_reset;
reg wdt_reset_n;
always @ (posedge rst or posedge wdt_rst_in)
begin
	if(rst)
		reset <= 1'b0;
	else
		reset <= ~reset_n;
end
always @ (posedge rst or posedge wdt_clk)
begin
	if(rst)
	begin
		reset_n <= 1'b0;
		wdt_reset <=1'b0;
		wdt_cnt <= 'h0000;
	end
	else if(reset != reset_n)
	begin
		reset_n <= reset;
		wdt_cnt <= 'h0000;
	end
	else if(wdt_clk)
	begin
		if(wdt_cnt[CNT_WIDTH])
		begin
			wdt_reset <= ~wdt_reset_n;
			wdt_cnt <= 'h0000;
		end
		else
		begin
			wdt_cnt <= wdt_cnt + 1;
		end
	end
end
always @ (posedge rst or posedge clk)
begin
	wdt_rst_out <= 1'b0;
	if(rst)
		wdt_reset_n <= 1'b1;
	else if(wdt_reset != wdt_reset_n)
	begin
		wdt_reset_n <= wdt_reset;
		wdt_rst_out <= 1'b1;
	end
end
endmodule