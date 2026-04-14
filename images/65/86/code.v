module top_module(clk, reset, mclk, mclk_ena, rate);parameter div = 8;      
    
	input clk;		
	input reset;	
	output mclk;	
	output mclk_ena;
	output rate;	
	
	
	wire [2:0] cnt_mask = div-1;
	reg [2:0] mclk_cnt;
	reg mclk_ena;
	always @(posedge clk)
		if(reset)
		begin
			mclk_cnt <= 3'b111;
			mclk_ena <= 1'b1;
		end
		else
		begin
			mclk_cnt <= mclk_cnt - 1;
			if((mclk_cnt & cnt_mask) == 3'b000)
				mclk_ena <= 1'b1;
			else
				mclk_ena <= 1'b0;
		end
		
	assign mclk = mclk_cnt[1];
	
	
	reg rate;
	reg [7:0] rate_cnt;
	always @(posedge clk)
		if(reset | rate)
			rate_cnt <= 8'd255;
		else if(mclk_ena)
			rate_cnt <= rate_cnt - 1;
	
	
	always @(posedge clk)
		rate <= ((rate_cnt == 8'd0) && ((mclk_cnt & cnt_mask) == 3'b000));
endmodule