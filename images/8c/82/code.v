module top_module(IDtoEX_RegRt,IDtoEX_MemRead,IFtoID_RegRs,IFtoID_RegRt,
              PCWrite,IFDWrite,IFD_Flush,IDEX_Flush,PCSrc);input IDtoEX_MemRead;
input [2:0] PCSrc;
input [4:0] IDtoEX_RegRt,IFtoID_RegRs,IFtoID_RegRt;
output reg PCWrite,IFDWrite,IFD_Flush,IDEX_Flush;

always @(*)
begin
  if(IDtoEX_MemRead && ((IDtoEX_RegRt==IFtoID_RegRs) || (IDtoEX_RegRt==IFtoID_RegRt))) 
  begin
    PCWrite=0;
    IFDWrite=0;
    IFD_Flush=0;
    IDEX_Flush=1;
  end
  else if(PCSrc==3'b010 || PCSrc==3'b011 || PCSrc==3'b001)   
  begin
    PCWrite=1;
    IFDWrite=1;
    IFD_Flush=1;
    IDEX_Flush=0;    
  end
  else
  begin
    PCWrite=1;
    IFDWrite=1;
    IFD_Flush=0;
    IDEX_Flush=0;
  end
end

endmodule