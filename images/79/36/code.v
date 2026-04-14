module top_module(input clk,input piso1,input piso2,input piso3,input piso4,input S1,input B2,input S2,input B3,input S3,input B4,output reg [3:0] boton_pres);initial begin 
  boton_pres = 0; 
 end 
 always @ (posedge clk) 
  begin 
  if (piso1) 
  boton_pres = 1; 
  else if (piso2) 
  boton_pres = 2; 
  else if (piso3) 
  boton_pres = 3; 
  else if (piso4) 
  boton_pres = 4; 
  else if (S1) 
  boton_pres = 5; 
  else if (B2) 
  boton_pres = 6; 
  else if (S2) 
  boton_pres = 7; 
  else if (B3) 
  boton_pres = 8; 
  else if (S3) 
  boton_pres = 9; 
  else if (B4) 
  boton_pres = 10; 
  else 
  boton_pres = 0; 
  end 
 endmodule