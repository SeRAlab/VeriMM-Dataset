module top_module(
		cnt_en,
		fifo_reset,
		scan_cnt_clr,
		cnt_clk, 

		scan_cnt_num
		);input	cnt_en,	
	fifo_reset,
	scan_cnt_clr;

input	cnt_clk;

output	[10:0]	scan_cnt_num;


reg	cout_reg,
	cout_reg_dly1,
	cout_reg_dly2;
reg	[10:0]	scan_cnt_num;
reg	[10:0]	tmp_data;
	
reg		scan_cnt_clr_dly1,
		scan_cnt_clr_dly2;

always @ (posedge cnt_clk)
begin
	scan_cnt_clr_dly1 <= scan_cnt_clr;
	scan_cnt_clr_dly2 <= scan_cnt_clr_dly1;
end

reg	[10:0]	record_scan_cnt;
reg		read_flag;


always @(posedge cnt_clk )
begin	
	if(!fifo_reset)
	begin
		tmp_data <= 16'h000;			
	end
	else if(cnt_en == 1'b1)
	begin
		tmp_data <= tmp_data + 1'b1;					
	end	
end
always @(posedge cnt_clk )
begin	
	if(!fifo_reset)
	begin
	  scan_cnt_num <= 16'h000;	
	end
    else if({scan_cnt_clr_dly2,scan_cnt_clr_dly1} ==2'b01) 
	begin
		scan_cnt_num <= tmp_data;	
	end
end

endmodule