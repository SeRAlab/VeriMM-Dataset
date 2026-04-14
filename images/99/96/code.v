module top_module(wrap64_setValidCap_cap,
				 wrap64_setValidCap_valid,
				 wrap64_setValidCap);input  [90 : 0] wrap64_setValidCap_cap;
  input  wrap64_setValidCap_valid;
  output [90 : 0] wrap64_setValidCap;

  
  wire [90 : 0] wrap64_setValidCap;

  
  assign wrap64_setValidCap =
	     { wrap64_setValidCap_valid, wrap64_setValidCap_cap[89:0] } ;
endmodule