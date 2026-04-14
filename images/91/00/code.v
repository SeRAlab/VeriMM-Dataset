module top_module(dq3, dq2, dq1, dq0,CLKDIV, srint, rst,SHO);input dq3, dq2, dq1, dq0; 
 input CLKDIV, srint, rst; 
 output SHO; 
 reg shr; 
 reg SHO; 
 wire clkint; 
 wire error; 
 wire rst_in, rst_self_heal; 
 wire [4:0] SELFHEAL; 
 assign SELFHEAL = 5'b00000; 
 parameter FFD = 10; 
 parameter FFCD = 10; 
 parameter MXD = 10; 
 parameter MXR1 = 10; 
 assign clkint = CLKDIV & SELFHEAL[4]; 
 assign error = (((~SELFHEAL[4] ^ SELFHEAL[3]) ^ dq3) | ((~SELFHEAL[4] ^ SELFHEAL[2]) ^ dq2) | ((~SELFHEAL[4] ^ SELFHEAL[1]) ^ dq1) | ((~SELFHEAL[4] ^ SELFHEAL[0]) ^ dq0)); 
 assign rst_in = (~SELFHEAL[4] | ~srint); 
 assign rst_self_heal = (rst | ~shr); 
 always @ (posedge clkint or posedge rst) 
 begin 
  begin 
  if (rst) 
  begin 
  shr <= # FFD 1'b0; 
  end 
  else begin 
  shr <= #FFD rst_in; 
  end 
  end 
 end 
 always @ (posedge clkint or posedge rst_self_heal) 
 begin 
  begin 
  if (rst_self_heal) 
  begin 
  SHO <= 1'b0; 
  end 
  else 
  begin 
  SHO <= # FFD error; 
  end 
  end 
 end 
 endmodule