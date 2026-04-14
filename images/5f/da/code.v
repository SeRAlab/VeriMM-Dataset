module top_module(input d, reset, enable, output reg q);always @( d or enable or reset)
    if(enable)
	    if(reset)
		    q <= 0;
		else	
	        q <= d;
endmodule