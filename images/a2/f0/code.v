module top_module(
    clk_i,
	 rst_n,
	 hour1,
	 hour0,
	 day_en
	 );input clk_i;
input rst_n;
output [3:0] hour1;
output [3:0] hour0;
output day_en;

reg [3:0] hour1;
reg [3:0] hour0;
reg day_en;

reg [3:0] hour1_tmp;
reg [3:0] hour0_tmp;
reg day_en_tmp;



always@(hour1 or hour0)
begin
	if(hour1==4'd2 && hour0==4'd3)
	begin
		hour1_tmp=4'd0;
		hour0_tmp=4'd0;
		day_en_tmp=1'b1;
	end
	else if(hour0==4'd9)
	begin
		hour1_tmp=hour1+4'd1;
		hour0_tmp=4'd0;
		day_en_tmp=1'b0;
	end
	else
	begin
		hour1_tmp=hour1;
		hour0_tmp=hour0+4'd1;
		day_en_tmp=1'b0;
	end
end



always@(posedge clk_i or negedge rst_n)
begin
	if(~rst_n)
	begin
		hour1<=4'd0;
		hour0<=4'd0;
		day_en<=1'b0;
	end
	else
	begin
		hour1<=hour1_tmp;
		hour0<=hour0_tmp;
		day_en<=day_en_tmp;
	end
end



endmodule