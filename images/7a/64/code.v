module top_module(
    a,
    b,
    out
);parameter WIDTH = 10;
    
    input   [WIDTH-1:0] a;
    input   [WIDTH-1:0] b;
    output  [WIDTH-1:0] out;
	
	wire    [WIDTH-1:0] diff = b-a;
    
    assign out = (diff[WIDTH-1]) ? a : b;
endmodule