module top_module(
    input [4:0] rs,
	 input [4:0] rt,
	 input [4:0] rd_EX,
	 input [4:0] rd_MEM,
	 input RegWrite_EX,
	 input RegWrite_MEM,
	 output reg [1:0] ALUScrA,
	 output reg [1:0] ALUScrB
	 );always@(*)
begin

ALUScrA = 2'b00;
ALUScrB = 2'b00;
if ((rs == rd_EX)&&(RegWrite_EX)) 
begin
ALUScrA = 2'b01;
end
else if ((rs == rd_MEM)&&(RegWrite_MEM)) 
begin
ALUScrA = 2'b10;
end
if ((rt == rd_EX)&&(RegWrite_EX)) 
begin
ALUScrB = 2'b01;
end
else if ((rt == rd_MEM)&&(RegWrite_MEM)) 
begin
ALUScrB = 2'b10;
end

end

endmodule