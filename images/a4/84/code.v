module top_module(input [2:0]SEL,output reg [3:0]RAMSEL,input [5:0]rstatus);always @* begin 
  RAMSEL = 4'bxxxx; 
  case(SEL) 
  0: RAMSEL = {rstatus[1], 3'b000}; 
  1: 
  if(rstatus[{1'b1, rstatus[1]}]) RAMSEL = {rstatus[1], 3'b010}; 
  else RAMSEL = {rstatus[1], 3'b001}; 
  2: 
  case({rstatus[5:4], rstatus[{1'b1, rstatus[1]}]}) 
  0,4: RAMSEL = {rstatus[1], 3'b010}; 
  1,5: RAMSEL = {rstatus[1], 3'b001}; 
  2,3: RAMSEL = 4'b0101; 
  6,7: RAMSEL = 4'b0110; 
  endcase 
  3: RAMSEL = {rstatus[0], 3'b011}; 
  4: RAMSEL = 4; 
  5: RAMSEL = 12; 
  6: RAMSEL = 13; 
  7: RAMSEL = 7; 
  endcase 
  end 
 endmodule