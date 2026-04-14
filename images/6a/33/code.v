module top_module(input A,input B,input GTI,input LTI,input EQI,output reg GTO,output reg LTO,output reg EQO);always @ (A or B or GTI or LTI or EQI) 
  begin 
  if ( A > B ) 
  begin 
  GTO = 1; 
  LTO = 0; 
  EQO = 0; 
  end 
  else if ( A < B ) 
  begin 
  LTO = 1; 
  GTO = 0; 
  EQO = 0; 
  end 
  else 
  begin 
  EQO = EQI; 
  GTO = GTI; 
  LTO = LTI; 
  end 
  end 
 endmodule