module top_module(in,out,clk,reset
    );input in,clk,reset;
output reg[7:0]out;
reg [3:0]count;
always@(posedge clk or negedge reset)begin
if(~reset)count<=0;
else begin
	if(count<=7)begin
	count<=count+1;
	end
	else begin
	count<=1;
	end
end
end
always@(count)begin
out[count-1]=in;
end
endmodule