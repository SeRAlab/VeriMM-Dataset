module top_module(
	input 	clk,		    	
	input 	reset,			   	
	input	[15:0] in,			
	output	reg [15:0] out,	
	input	rd,					
	input	wr,					
	output	reg empty,			
	output	full,				
	output	[11:0] cnt       
);reg 	[15:0] mem [2047:0];	
reg		[11:0] in_ptr;			
reg		[11:0] out_ptr;			
wire	equal;					



assign cnt = in_ptr - out_ptr;


always @(posedge clk)
	if (wr)
		mem[in_ptr[10:0]] <= in;

always @(posedge clk)
	out=mem[out_ptr[10:0]];


always @(posedge clk)
	if (reset)
		in_ptr[11:0] <= 0;
	else if(wr)
		in_ptr[11:0] <= in_ptr[11:0] + 12'd1;


always @(posedge clk)
	if (reset)
		out_ptr[11:0] <= 0;
	else if (rd)
		out_ptr[11:0] <= out_ptr[11:0] + 12'd1;


assign equal = (in_ptr[10:0]==out_ptr[10:0]) ? 1'b1 : 1'b0;


always @(posedge clk)
	if (equal && (in_ptr[11]==out_ptr[11]))
		empty <= 1'b1;
	else
		empty <= 1'b0;
		
assign full = (equal && (in_ptr[11]!=out_ptr[11])) ? 1'b1 : 1'b0;	

endmodule