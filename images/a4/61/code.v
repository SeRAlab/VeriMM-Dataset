module top_module(IDEX_Rs, IDEX_Rt, EXMEM_RegWrite, EXMEM_Rd, MEMWB_RegWrite, MEMWB_Rd, ALUOp, ForwardA, ForwardB);input [4:0] IDEX_Rs, IDEX_Rt, EXMEM_Rd, MEMWB_Rd; 
input EXMEM_RegWrite, MEMWB_RegWrite; 
input [1:0] ALUOp; 

output [1:0] ForwardA, ForwardB; 

reg [1:0] A,B; 

always @(IDEX_Rs or IDEX_Rt or EXMEM_RegWrite or EXMEM_Rd or MEMWB_RegWrite or MEMWB_Rd) 
begin



  A=2'b00;
  B=2'b00;



  if((EXMEM_RegWrite==1'b1)&&(EXMEM_Rd!=0)&&(EXMEM_Rd==IDEX_Rs))
  begin
    if(ALUOp==2'b10) 
	A=2'b11;
    else
	A=2'b10;
  end

  if((EXMEM_RegWrite==1'b1)&&(EXMEM_Rd!=0)&&(EXMEM_Rd==IDEX_Rt))
  begin
    if(ALUOp==2'b10)
	B=2'b11;
    else
	B=2'b10;
  end



  if((MEMWB_RegWrite==1'b1)&&(MEMWB_Rd!=0)&&(MEMWB_Rd==IDEX_Rs)&&(EXMEM_Rd!=IDEX_Rs))
  begin
    A=2'b01;
  end

  if((MEMWB_RegWrite==1'b1)&&(MEMWB_Rd!=0)&&(MEMWB_Rd==IDEX_Rt)&&(EXMEM_Rd!=IDEX_Rt))
  begin
    B=2'b01;
  end
end

assign ForwardA=A;
assign ForwardB=B;endmodule