module top_module(
	clk, 		
	enable, 	
	reset, 		
	framesize, 	
	in, 		
	out, 		
	complete	
);parameter BITS = 32;		
	parameter BITS_COUNTER = 8;	

	input clk, enable, reset, in;
	input [BITS_COUNTER-1:0] framesize;

	output reg complete;
	output reg [BITS-1:0] out;
	reg [BITS_COUNTER-1:0] counter;	


	
	
		
		
		
	




	always@(posedge clk) begin

	if (reset==1'b1) begin
		out <= 32'b00000000000000000000000000000000;
		counter <= 8'b00000000;

	end
	else  begin
		if(enable) begin
	   if (complete==1'b0) begin


				out[counter] <= in;
				counter  <= counter + 1;	
				 end
			end
			end
end

always @ ( * ) begin
	if (counter==framesize) begin
		complete=1'b1;
		end
		else begin
complete=1'b0;
		end
end


	
		
	




endmodule