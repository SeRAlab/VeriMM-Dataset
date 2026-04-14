module top_module(tw,tr_data);output [ 35: 0] tr_data; 
  input [ 35: 0] tw; 
  wire [ 35: 0] tr_data; 
  assign tr_data = 0 ? tw : 0; 
 endmodule