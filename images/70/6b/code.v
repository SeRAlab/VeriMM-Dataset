module top_module(
		a, 
		w,
		x
    );parameter wide = 3 * 3 * 512;
	
    input [wide-1 : 0] a;
    input [wide-1 : 0] w;

    output [wide-1 : 0] x;

    
    wire  [wide-1 : 0] x;
    assign x = a ~^ w;

endmodule