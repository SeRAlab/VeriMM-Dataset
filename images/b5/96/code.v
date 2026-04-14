module top_module(EXtoMEM_RegWrite,MEMtoWB_RegWrite,
                       EXtoMEM_RegRd,MEMtoWB_RegRd,
                       IDtoEX_RegRs,IDtoEX_RegRt,
                       ForwardA,ForwardB);input EXtoMEM_RegWrite,MEMtoWB_RegWrite;
input [4:0] EXtoMEM_RegRd,MEMtoWB_RegRd,IDtoEX_RegRs,IDtoEX_RegRt;
output reg [1:0] ForwardA,ForwardB;

always @(*)
begin
  
  if(EXtoMEM_RegWrite && (EXtoMEM_RegRd!=5'b00000) && (EXtoMEM_RegRd==IDtoEX_RegRs))
    ForwardA=2'b10;
  else if(MEMtoWB_RegWrite && (MEMtoWB_RegRd!=5'b00000) && (MEMtoWB_RegRd==IDtoEX_RegRs) 
          && (EXtoMEM_RegRd!=IDtoEX_RegRs || ~EXtoMEM_RegWrite))
    ForwardA=2'b01;
  else
    ForwardA=2'b00;
  
  if(EXtoMEM_RegWrite && (EXtoMEM_RegRd!=5'b00000) && (EXtoMEM_RegRd==IDtoEX_RegRt))
    ForwardB=2'b10;
  else if(MEMtoWB_RegWrite && (MEMtoWB_RegRd!=5'b00000) && (MEMtoWB_RegRd==IDtoEX_RegRt) 
          && (EXtoMEM_RegRd!=IDtoEX_RegRt || ~EXtoMEM_RegWrite))
    ForwardB=2'b01;
  else
    ForwardB=2'b00;  
end 
   
endmodule