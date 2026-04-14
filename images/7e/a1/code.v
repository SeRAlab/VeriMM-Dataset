module top_module(Q, G_,D);output Q; 
 input G_, D; 
  reg Q; 
 always @ (G_ or D) begin 
  if (G_==0) Q <= #1 D; 
 end 
 endmodule