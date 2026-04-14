module top_module(
	input clk,
	input [31:0]freq,
	input stop,
	input reset,
	
	output reg done,
	output reg clk_out
	

);reg [31:0] count;



always@(posedge clk)begin
if(reset) begin
	count=0;
	clk_out=0;
	done=0;
end 
else begin
	if(~stop)begin

		if(count == freq) begin
			count=0;
			clk_out=~clk_out;
		end
		else begin
			count=count+1;
			done=0;
		end
	end
	else begin
		count=0;
		clk_out=0;
		done=1;
	end
end
end

endmodule