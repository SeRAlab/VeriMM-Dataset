module top_module(C, D, Q, S, R);input C, D, S, R; 
 output reg Q; 
 always @(posedge C, posedge S, posedge R) 
  if (S) 
  Q <= 1'b1; 
  else if (R) 
  Q <= 1'b0; 
  else 
  Q <= D; 
 `ifdef DEBUGM 
 parameter power_rev_time=`PRTIME; 
 wire [31:0] contador; 
 reg enb; 
 potencia p(contador,enb,Q); 
 integer cur_time; 
 initial 
 begin 
  enb=1; 
  #(`PRTIME) $display("%d", contador); 
 end 
 `endif 
 endmodule