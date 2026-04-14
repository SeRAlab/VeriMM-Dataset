module top_module(wrap64_setPerms_cap,
			      wrap64_setPerms_perms,
			      wrap64_setPerms);input  [90 : 0] wrap64_setPerms_cap;
  input  [30 : 0] wrap64_setPerms_perms;
  output [90 : 0] wrap64_setPerms;

  
  wire [90 : 0] wrap64_setPerms;

  
  assign wrap64_setPerms =
	     { wrap64_setPerms_cap[90:50],
	       wrap64_setPerms_perms[11:0],
	       wrap64_setPerms_cap[37:0] } ;
endmodule