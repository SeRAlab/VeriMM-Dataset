module top_module(
	bit1,
	bit2,
	bit3	
	);input bit1;
  input bit2;
  output bit3;
  
  assign bit3 = bit1 & bit2;
 
endmodule