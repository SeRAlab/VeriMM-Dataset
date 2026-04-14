module holes_filler(clk,datavalid,pix_in_current,pix_in_previous,left,pix_out);
input clk,datavalid,pix_in_current,pix_in_previous;
output reg left;
output pix_out;
reg top,x,right;
always@(posedge clk)
	if(datavalid)begin
		top<=pix_in_previous;
		left<=x;x<=right;right<=pix_in_current;
	end
assign pix_out=(top&(left|right))?1'd1:x;
endmodule