module top_module(output [15 : 0] data_out,input [2 : 0] load,input [15 : 0] data_in);assign data_out = 
  (load == 0) ? {{8{data_in[7]}}, data_in[7 : 0]} : 
  (load == 1) ? {{12{data_in[3]}}, data_in[3 : 0]} : 
  (load == 2) ? {{5{data_in[10]}}, data_in[10 : 0]} : 
  (load == 3) ? {12'b0, data_in[3 : 0]} : 
  (load == 4) ? {8'b0, data_in[7 : 0]} : 
  (load == 5) ? {{11{data_in[4]}}, data_in[4 : 0]} : 
  {13'b0, data_in[4 : 2]}; 
 endmodule