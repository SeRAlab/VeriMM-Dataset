module top_module(data_out, empty, full, data_in, push, pop, reset, clk);parameter DEPTH = 8;			
	
	parameter WIDTH = 8;
	
		
	
	
	
	
	
	
	output [WIDTH-1:0] data_out;
	
	output empty;
	
	output full;
	
	
	
	
	
	
	input [WIDTH-1:0] data_in;
	
	input push;
	
	input pop;
	
	input reset;
	
	input clk;
	
	
	
	
	
	
	
	



	
	
	
	reg [WIDTH-1:0] data_out;		
	reg empty,full;					
	
	reg [DEPTH-1:0] wraddr, rdaddr;
	
	
	
	
	
	reg [DEPTH-1:0] reg_file [WIDTH-1:0];
	reg [DEPTH-1:0] num_elems;
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	always @(reset)
	begin
		data_out=8'd0;
		empty=1'd0;
		full=1'd0;
		
		wraddr=8'd0;
		rdaddr=8'd0;
		num_elems=8'd0;
	end
	
	
	
	
	
	
	
	
	
	
	always @(posedge clk)
	begin
		
	
		if(push && (~full) && (~pop))
		begin
			reg_file[wraddr] = data_in;
			wraddr=(wraddr+1)%DEPTH;
			num_elems=num_elems+1;
			
			if(empty)
			begin
				empty=1'd0;
			end

			
			
			if((wraddr==rdaddr) &&(~empty) && (num_elems==DEPTH))
			begin
				
				full=1'd1;
			end
			else
			begin
				
				full=1'd0;
			end
		end
		else if(pop && (~empty) && (~push))
		begin
			data_out=reg_file[rdaddr];
			rdaddr=(rdaddr+1)%DEPTH;
			num_elems=num_elems-1;
			
			if(full)
			begin
				full=1'd0;
			end
			
			
			if(wraddr==rdaddr)
			begin
				
				empty=1'd1;
			end
			else
			begin
				
				empty=1'd0;
			end
		end

	end
	
	
endmodule