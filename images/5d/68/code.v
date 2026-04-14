module top_module(input wire [1:0] Data_i,input wire [1:0] Round_Type_i,input wire Sign_Result_i,output reg Round_Flag_o);always @* 
  case ({Sign_Result_i,Round_Type_i,Data_i}) 
  5'b10101: Round_Flag_o <=1; 
  5'b10110: Round_Flag_o <=1; 
  5'b10111: Round_Flag_o <=1; 
  5'b01001: Round_Flag_o <=1; 
  5'b01010: Round_Flag_o <=1; 
  5'b01011: Round_Flag_o <=1; 
  default: Round_Flag_o <=0; 
  endcase 
 endmodule