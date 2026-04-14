module top_module(dataa, datab, add_sub, result);input [35:0] dataa,datab; 
  input add_sub; 
  output [35:0] result; 
  assign result = dataa + (add_sub ? datab : ~datab) + {35'd0,~add_sub}; 
 endmodule