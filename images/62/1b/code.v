module top_module(wrap64_isSentry_cap,
			      wrap64_isSentry);input  [90 : 0] wrap64_isSentry_cap;
  output wrap64_isSentry;

  
  wire wrap64_isSentry;

  
  assign wrap64_isSentry = wrap64_isSentry_cap[36:33] == 4'd14 ;
endmodule