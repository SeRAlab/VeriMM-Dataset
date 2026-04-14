module top_module(data_in ,key,data_out );input [0:127] data_in,key;
  output[0:127] data_out;
  
  assign data_out = data_in^key ;
endmodule