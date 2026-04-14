module top_module(
	idex_Rs,
	idex_Rt,
	exmem_Rd,
	exmem_RegWrite,
	memwb_Rd,
	memwb_RegWrite,
	ForwardA,
	ForwardB
	);input [4:0] idex_Rs;
input [4:0] idex_Rt;
input [4:0] exmem_Rd;
input [4:0] memwb_Rd;
input       exmem_RegWrite;
input       memwb_RegWrite;

output [1:0] ForwardA;
output [1:0] ForwardB;

reg [1:0] ForwardA;
reg [1:0] ForwardB;

always@(*) begin
	if(exmem_RegWrite == 1'b1 && exmem_Rd == idex_Rs && exmem_Rd != 5'd0) 
		ForwardA = 2'b01;	
	else if(memwb_RegWrite == 1'b1 && memwb_Rd == idex_Rs && memwb_Rd != 5'd0 && (~(exmem_RegWrite == 1'b1 && exmem_Rd != 5'd0 && exmem_Rd == idex_Rs)))
		ForwardA = 2'b10;	
	else
		ForwardA = 2'b00;
	
	if(exmem_RegWrite == 1'b1 &&  exmem_Rd == idex_Rt && exmem_Rd != 5'd0) 
		ForwardB = 2'b01;	
	else if(memwb_RegWrite == 1'b1 &&  memwb_Rd == idex_Rt && memwb_Rd != 5'd0 && (~(exmem_RegWrite == 1'b1 && exmem_Rd != 5'd0 && exmem_Rd == idex_Rt)) )
		ForwardB = 2'b10;	
	else
		ForwardB = 2'b00;
		
end

endmodule