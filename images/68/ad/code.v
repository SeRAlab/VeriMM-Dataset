module top_module(
	input	clk,			
	input	cnt,			
	input	mrst,			
	output	reset			
);reg		smrst0, smrst1;					
reg		[2:0] rst_cnt = 0;		
wire	_rst;					


always @(posedge clk) begin
  smrst0 <= mrst;
	smrst1 <= smrst0;
end


always @(posedge clk)
	if (smrst1)
		rst_cnt <= 3'd0;
	else if (!_rst && cnt)
		rst_cnt <= rst_cnt + 3'd1;

assign _rst = rst_cnt[2];


assign reset = ~_rst;

endmodule