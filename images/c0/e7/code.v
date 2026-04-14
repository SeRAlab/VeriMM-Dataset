module row_buf(clk,datavalid,pix_in,pix_out1,pix_out2);
parameter length=640;
input clk,datavalid,pix_in;
output pix_out1,pix_out2;
reg [length-1:0] R;
always@(posedge clk)begin
	if(datavalid)begin
		R[length-1:1]<=R[length-2:0];
		R[0]<=pix_in;
	end
end
assign pix_out1=R[length-1];
assign pix_out2=R[length-2];
endmodule