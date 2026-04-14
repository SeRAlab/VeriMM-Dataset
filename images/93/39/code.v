module top_module(CLKA,RSTA,ADDRA,DIA,ENA,WEA,DOA,CLKB,RSTB,ADDRB,DIB,ENB,WEB,DOB);parameter dw = 16; 
 parameter aw = 8; 
 input CLKA, RSTA, ENA, WEA, CLKB, RSTB, ENB, WEB; 
 input [dw-1:0] DIA, DIB; 
 output [dw-1:0] DOA, DOB; 
 input [aw-1:0] ADDRA, ADDRB; 
 reg [dw-1:0] mem [(1<<aw)-1:0]; 
 reg [aw-1:0] addr_reg_a; 
 reg [aw-1:0] addr_reg_b; 
 assign DOA = mem[addr_reg_a][dw-1:0]; 
 assign DOB = mem[addr_reg_b][dw-1:0]; 
 always @(posedge CLKA or posedge RSTA) 
  if ( RSTA == 1'b1 ) 
  addr_reg_a <= #1 {aw{1'b0}}; 
  else if ( ENA ) 
  addr_reg_a <= #1 ADDRA; 
 always @(posedge CLKB or posedge RSTB) 
  if ( RSTB == 1'b1 ) 
  addr_reg_b <= #1 {aw{1'b0}}; 
  else if ( ENB ) 
  addr_reg_b <= #1 ADDRB; 
 always @(posedge CLKA) 
  if (ENA && WEA) 
  mem[ADDRA] <= #1 DIA; 
 always @(posedge CLKB) 
  if (ENB && WEB) 
  mem[ADDRB] <= #1 DIB; 
 endmodule