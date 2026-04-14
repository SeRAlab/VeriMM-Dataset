module window(clk,datavalid,pix_in_current,pix_in_previous,A,B,C,D);
input clk,datavalid,pix_in_current,pix_in_previous;
output reg A,B,C,D;
always@(posedge clk)
	if(datavalid)begin
		A<=B;B<=pix_in_previous;
		C<=D;D<=pix_in_current;
	end
endmodule