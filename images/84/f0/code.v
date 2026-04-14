module top_module(Q,D0,D1,C0,C1);input D0,D1,C0,C1; 
 output Q; 
 reg Q; 
 initial Q=0; 
 always @(posedge C0) Q=D0; 
 always @(posedge C1) Q=D1; 
 endmodule