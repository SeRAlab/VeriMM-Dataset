module top_module(a,b, y);input [3:0] a, b;
  	  	output [7:0] y;
  	  	wire [7:0] y;
  	  	 
  	  	assign y = {a,b};
  	  	 
endmodule