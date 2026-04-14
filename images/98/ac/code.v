module top_module(rdata1,rdata2,clk,rst,rdsel1,rdsel2,wtsel,wtdata,wenable);input rst,clk; 
input [4:0] rdsel1; 
input [4:0] rdsel2; 
input [4:0] wtsel; 
input wenable; 
input [31:0] wtdata; 
output reg[31:0] rdata1; 
output reg[31:0] rdata2; 
integer i;
reg [31:0] memory [31:0]; 
always @ (posedge clk or negedge rst)
begin
	if (rst==0) 
	begin
		for (i=0;i<32;i=i+1) 
			memory[i] <= 0;
		rdata1 <= 0;
		rdata2 <= 0;
	end
	else
	begin
		rdata1<=memory[rdsel1];
		rdata2<=memory[rdsel2];
		if (wenable == 1)
		begin
			memory[wtsel] <= wtdata;
		end
	end 
end
endmodule