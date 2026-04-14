module top_module(se, so_0,global_shift_enable, ctu_tst_scan_disable,ctu_tst_short_chain, long_chain_so_0, short_chain_so_0);input global_shift_enable; 
  input ctu_tst_scan_disable; 
  input ctu_tst_short_chain; 
  input long_chain_so_0; 
  input short_chain_so_0; 
  output se; 
  output so_0; 
  wire short_chain_select; 
  assign se = ~ctu_tst_scan_disable & global_shift_enable; 
  assign short_chain_select = ctu_tst_short_chain; 
  assign so_0 = short_chain_select ? short_chain_so_0 : long_chain_so_0; 
 endmodule