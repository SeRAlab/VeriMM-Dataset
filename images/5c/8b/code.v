module top_module(a,b,sel,y);input [3:0]a;
		input [3:0]b;
   	  	output [3:0]y;
   	  	input sel;
   	  
   	  	 
   	  	assign y = (sel) ? b : a;
   	  	 
 endmodule