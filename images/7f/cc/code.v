module top_module(Q_, G1,G2, D1,D2);output Q_; 
 input G1, G2, D1, D2; 
  reg Q_; 
 always @ (G1 or G2 or D1 or D2) begin 
  if ((G1==1) & (G2==0)) Q_ <= #1 D1; 
  else if ((G1==0) & (G2==1)) Q_ <= #1 D2; 
 end 
 endmodule