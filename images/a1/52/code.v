module top_module(Q,A,clk,reset);parameter m=163; 
  input wire[0:m-1] A; 
  output wire[0:m-1] Q; 
  reg[0:m-1] Q1; 
  input wire clk,reset; 
  assign Q=Q1; 
  initial 
  begin 
  Q1=163'd0; 
  end 
  always@(posedge clk or negedge reset) 
  if(~reset)begin 
  Q1<=163'd0; 
  end 
  else begin 
  Q1 <= A; 
  end 
 endmodule