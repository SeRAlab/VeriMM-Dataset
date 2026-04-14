module top_module(en,out,in1,in2,clk,reset);input [20:0]in1,in2;
input clk,reset;
input en;

output [20:0]out;

reg [20:0]out;
wire [20:0]im1;
wire [20:0]p;
wire [19:0]g;
wire [20:0]c;
wire [20:0]sum;

assign im1=~in1;
assign p=im1^in2;
assign g=im1[19:0]&in2[19:0];
assign c[0]=1;
assign c[20:1]=g[19:0]|p[19:0]&c[19:0];
assign sum=p^c;

always@(posedge clk or negedge reset)
begin
	if(reset==0)
	begin
		out<=0;
	end
	else
	begin
		if(en==1)
		begin
			out<=sum;
		end
	end
end
endmodule