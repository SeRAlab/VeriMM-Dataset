module top_module(
EX_Flush_i,
RegWrite_i,
MemtoReg_i, 
RegWrite_o, 
MemtoReg_o 
);input EX_Flush_i;
input RegWrite_i;
input MemtoReg_i; 

output reg RegWrite_o; 
output reg MemtoReg_o; 

always @(*) begin
if(EX_Flush_i == 0) begin
	RegWrite_o = RegWrite_i;
	MemtoReg_o = MemtoReg_i;
end
else begin
	RegWrite_o = 0;
	MemtoReg_o = 0;
end
end

endmodule