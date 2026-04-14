module top_module(rst_l_buf, se_buf, adbginit_l_buf,rst_l, se, adbginit_l);output rst_l_buf ; 
  output se_buf ; 
  output adbginit_l_buf ; 
  input rst_l ; 
  input se ; 
  input adbginit_l ; 
  assign rst_l_buf = rst_l; 
  assign se_buf = se; 
  assign adbginit_l_buf = adbginit_l ; 
 endmodule