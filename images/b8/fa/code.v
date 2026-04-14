module top_module(
			select,
			z,
			x,	
			y	
		);input 			select;
input	[31:0]	z;
output	[31:0] 	x,
				y;
				
assign x = (select) ? z  : 32'h0;
assign y = (~select) ? z : 32'h0;
		
endmodule