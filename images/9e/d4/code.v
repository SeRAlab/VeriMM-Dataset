module top_module(input A,input B,input CARRY_IN,output SUM,output CARRY_OUT);assign SUM = (A ^ B) ^ CARRY_IN; 
  assign CARRY_OUT = (A & ~B & CARRY_IN) | (~A & B & CARRY_IN) | (A & B); 
 endmodule