module top_module(	
	in,
    
	out
);parameter INPUT_DWIDTH = 16;
	parameter OUTPUT_DWIDTH = 32;

   input	[INPUT_DWIDTH-1:0]	in;
	
   output [OUTPUT_DWIDTH-1:0] out; 
		
	localparam SIGN_BIT_LOCATION = INPUT_DWIDTH-1;
	localparam SIGN_BIT_REPLICATION_COUNT = OUTPUT_DWIDTH - INPUT_DWIDTH;
	
	assign out = {{SIGN_BIT_REPLICATION_COUNT{in[SIGN_BIT_LOCATION]}},in[INPUT_DWIDTH-1:0]};
    
endmodule