module top_module (
    input m, 
    input n, 
    output o);assign o = (~m & n) | (m & n);
	
endmodule