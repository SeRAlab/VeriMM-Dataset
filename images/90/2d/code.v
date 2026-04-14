module top_module (
    input w, 
    input x, 
    output y);assign y = (~w & x) | (w & ~x);
	
endmodule