module top_module(data_out, data_in, wraddr, rdaddr, wren, clk);parameter DEPTH = 8;			
	
	parameter WIDTH = 8;
	
		
	
	
	
	
	
	
	
	output [WIDTH-1:0] data_out;
	
	
	
	
	
	
	input [WIDTH-1:0] data_in;
	
	input clk;
	
	input wren;
	
	input [DEPTH-1:0] wraddr, rdaddr;
	
	
	
	
	
	
	



	
	
	
	reg [WIDTH-1:0] data_out;		
	reg [DEPTH-1:0] reg_file [WIDTH-1:0];

	
	
	
	
	
	
	always @(posedge clk)
	begin
		if(wren)
		begin
			reg_file[wraddr] <= data_in;
		end
		else
		begin
			data_out<=reg_file[rdaddr];
		end
	end
	
	
	
	
endmodule