module top_module(
	input 	clk,					
	input 	reset,		    		
	input	aen,					
	input	[1:0] address,		   	
	input	[8:0] hpos,				
	input 	[15:0] data_in, 		
	output	[1:0] sprdata,			
	output	reg attach				
);parameter POS  = 2'b00;  		
parameter CTL  = 2'b01;  		
parameter DATA = 2'b10;  		
parameter DATB = 2'b11;  		


reg		[15:0] datla;		
reg		[15:0] datlb;		
reg		[15:0] shifta;		
reg		[15:0] shiftb;		
reg		[8:0] hstart;		
reg		armed;				
reg		load;				
reg		load_del;




always @(posedge clk)
	if (reset) 
		armed <= 0;
	else if (aen && address==CTL) 
		armed <= 0;
	else if (aen && address==DATA) 
		armed <= 1;




always @(posedge clk)
	load <= armed && hpos[8:0]==hstart[8:0] ? 1'b1 : 1'b0;

always @(posedge clk)
	load_del <= load;




always @(posedge clk)
	if (aen && address==POS)
		hstart[8:1] <= data_in[7:0];


always @(posedge clk)
	if (aen && address==CTL)
		{attach,hstart[0]} <= {data_in[7],data_in[0]};


always @(posedge clk)
	if (aen && address==DATA)
		datla[15:0] <= data_in[15:0];


always @(posedge clk)
	if (aen && address==DATB)
		datlb[15:0] <= data_in[15:0];




always @(posedge clk)
	if (load_del) 
	begin
		shifta[15:0] <= datla[15:0];
		shiftb[15:0] <= datlb[15:0];
	end
	else 
	begin
		shifta[15:0] <= {shifta[14:0],1'b0};
		shiftb[15:0] <= {shiftb[14:0],1'b0};
	end


assign sprdata[1:0] = {shiftb[15],shifta[15]};



endmodule