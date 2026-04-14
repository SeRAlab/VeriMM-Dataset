module top_module(input RST,input CLK,input STM,output reg ENp,output reg ENq,output reg[3:0] ENa,output reg[3:0] ENr,output reg EOM);reg[2:0] Qp,Qn; 
  always @ * 
  begin : Combinacional 
  case (Qp) 
  3'b000 : begin 
  if (STM) 
  Qn = 3'b001; 
  else 
  Qn = Qp; 
  ENp = 1'b0; 
  ENq = 1'b0; 
  ENa = 4'b0000; 
  ENr = 4'b0000; 
  EOM = 1'b1; 
  end 
  3'b001 : begin 
  Qn = 3'b010; 
  ENp = 1'b1; 
  ENq = 1'b0; 
  ENa = 4'b0001; 
  ENr = 4'b0000; 
  EOM = 1'b0; 
  end 
  3'b010 : begin 
  Qn = 3'b011; 
  ENp = 1'b1; 
  ENq = 1'b1; 
  ENa = 4'b0111; 
  ENr = 4'b0001; 
  EOM = 1'b0; 
  end 
  3'b011 : begin 
  Qn = 3'b100; 
  ENp = 1'b0; 
  ENq = 1'b1; 
  ENa = 4'b1110; 
  ENr = 4'b0110; 
  EOM = 1'b0; 
  end 
  3'b100 : begin 
  Qn = 3'b000; 
  ENp = 1'b0; 
  ENq = 1'b0; 
  ENa = 4'b1110; 
  ENr = 4'b1000; 
  EOM = 1'b0; 
  end 
  endcase 
  end 
  always @ (posedge RST or posedge CLK) 
  begin : Secuencial 
  if (RST) 
  Qp <= 0; 
  else 
  Qp <= Qn; 
  end 
 endmodule