module top_module(
	input clk,
	input rst_n,
	output sink_sop,
	output sink_eop
);reg [10:0] counter;

always@(posedge clk)
if(!rst_n)
	counter<=11'd0;
else if(counter>=11'd1030)
	counter<=11'd0;
else
	counter<=counter+1'b1;
	

assign sink_sop=(counter==11'd0)?1'b1:1'b0;

assign sink_eop=(counter==11'd1023)?1'b1:1'b0;

endmodule