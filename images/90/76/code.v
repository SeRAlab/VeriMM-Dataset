module top_module(
	input 	clk28m,		   		
	input	c1,
	input	c3,
	input	load,				
	input	hires,				
	input	shres,				
	input	[15:0] data_in,		
	input	[3:0] scroll,		
	output	out					
);reg		[15:0] shifter;			
reg		[15:0] scroller;		
reg		shift;					
reg	 	[3:0] select;			
wire	scroller_out;
reg		[3:0] delay;




always @(posedge clk28m)
	if (load && !c1 && !c3) 
		shifter[15:0] <= data_in[15:0];
	else if (shift) 
		shifter[15:0] <= {shifter[14:0],1'b0};

always @(posedge clk28m)
	if (shift) 
		scroller[15:0] <= {scroller[14:0],shifter[15]};

assign scroller_out = scroller[select[3:0]];




always @(posedge clk28m)
	delay[3:0] <= {delay[2:0], scroller_out};
	

assign out = delay[3];




always @(hires or shres or scroll or c1 or c3)
	if (shres) 
	begin
		shift = 1'b1; 
		select[3:0] = {scroll[1:0],2'b11}; 
	end
	else if (hires) 
	begin
		shift = ~c1 ^ c3; 
		select[3:0] = {scroll[2:0],1'b1}; 
	end
	else 
	begin
		shift = ~c1 & ~c3; 
		select[3:0] = scroll[3:0]; 
	end
			
endmodule