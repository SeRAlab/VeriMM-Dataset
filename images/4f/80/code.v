module top_module( output Run,output R1in, output R1out,output R2in, output R2out,output Add, output Sub, output Mul, output Div,output SelectY, output Yin,output Zin, output Zout,output End,input [15:0] T, input [3:0] Ins);assign Run = 1; 
  assign R1in = T[0]; 
  assign R1out = T[2]; 
  assign R2in = T[4] + T[1]; 
  assign R2out = T[3]; 
  assign Add = T[3] & Ins[0] ; 
  assign Sub = T[3] & Ins[1]; 
  assign Mul = T[3] & Ins[2]; 
  assign Div = T[3] & Ins[3]; 
  assign SelectY = T[3]; 
  assign Zin = T[3]; 
  assign Zout = T[4]; 
  assign Yin = T[2]; 
  assign End = T[5]; 
 endmodule