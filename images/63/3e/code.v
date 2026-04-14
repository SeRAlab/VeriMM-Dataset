module top_module(in1,in2,AluCtrOut,zero,AluRes);input wire [31:0] in1;
input wire [31:0] in2;
input wire [3:0]  AluCtrOut;
output reg [31:0] AluRes;
output reg zero;

always@(*)
begin
if(AluCtrOut == 4'b0010)	
	AluRes = in1 + in2;		
else if(AluCtrOut == 4'b0110)	
	AluRes = in1 - in2;
else if(AluCtrOut == 4'b0000)	
	AluRes = in1 & in2;
else if(AluCtrOut == 4'b0001)	
	AluRes = in1 | in2;
else if(AluCtrOut == 4'b0111)	
begin	
	if(in1 < in2)	AluRes = 32'b1;
	else		AluRes = 32'b0;
end
else 
	AluRes = 32'b0;
end

always@(*)
begin
if(in1 - in2 == 0)
	zero = 1;
else
	zero = 0;
end

endmodule