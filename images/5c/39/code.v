module top_module(IFID_Rs, IFID_Rt, IDEX_MemRead, IDEX_Rt, IFID_Write, PC_Write, Stall);input [4:0] IFID_Rs, IFID_Rt, IDEX_Rt; 
input IDEX_MemRead; 

output IFID_Write, PC_Write, Stall; 

reg IFID_Write_reg, PC_Write_reg, Stall_reg; 

always @(IFID_Rs, IFID_Rt, IDEX_MemRead, IDEX_Rt) 
begin



  IFID_Write_reg=1;
  PC_Write_reg=1;
  Stall_reg=0;

  if((IDEX_MemRead==1)&&((IDEX_Rt==IFID_Rs)||(IDEX_Rt==IFID_Rt)))
  begin



    IFID_Write_reg=0;
    PC_Write_reg=0;
    Stall_reg=1;

  end
end

assign IFID_Write=IFID_Write_reg;
assign PC_Write=PC_Write_reg;
assign Stall=Stall_reg;endmodule