module top_module(
	input clk,
	input n_rst,
	input en,
	output reg rst_ref_cnt,
	output its_fr_time
);parameter OFF = 0,
			 ON  = 1;


reg [21:0] refresh_period_time;
parameter REFRESH_PERIOD = 3840000 - 1;

parameter REFRESHES_PER_tRFC = 8192;
parameter FORCE_REFRESH_TIME = (REFRESH_PERIOD - (REFRESHES_PER_tRFC*5));

assign its_fr_time = (refresh_period_time >= (FORCE_REFRESH_TIME - 3));

always@(posedge clk or negedge n_rst)
begin
	if(n_rst == 0)
		begin
			refresh_period_time = 0;
			rst_ref_cnt = ON;
		end
	else if(en == ON)
		begin
			if(refresh_period_time < REFRESH_PERIOD)
				begin
					refresh_period_time = refresh_period_time + 1;
					rst_ref_cnt = OFF;
				end
			else 
				begin
					refresh_period_time = 0;
					rst_ref_cnt	= ON;
				end
		end
end

endmodule