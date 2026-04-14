module top_module( clock, resetn, enable, valid_in, valid_out, stall_in, stall_out, dataa, result);parameter WIDTH = 32;
	parameter HIGH_CAPACITY = 1;
	
	input clock, resetn;
	input enable, valid_in, stall_in;
	output valid_out, stall_out;
	input [WIDTH-1:0] dataa;
	output [31:0] result;
	
	
	reg c1_valid;
	wire c1_stall;
	wire c1_enable = (HIGH_CAPACITY == 1) ? (~c1_valid | ~c1_stall) : enable;
	assign stall_out = c1_valid & c1_stall;
	reg [31:0] c1_exponent;
	
	always@(posedge clock or negedge resetn)
	begin
		if (~resetn)
		begin
      c1_valid <= 1'b0;
      c1_exponent <= 32'dx;
		end
		else if (c1_enable)
		begin
			c1_valid <= valid_in;
			if (WIDTH==32)
			begin
			  if ((~(|dataa[WIDTH-2:WIDTH-9])) || (&dataa[WIDTH-2:WIDTH-9]))
				begin
					c1_exponent <= 32'h7fffffff;
				end
				else
				begin
					c1_exponent <= {1'b0, dataa[WIDTH-2:WIDTH-9]} - 9'd127;
				end
			end
			else
			begin
			  if ((~(|dataa[WIDTH-2:WIDTH-12])) || (&dataa[WIDTH-2:WIDTH-12]))
				begin
					c1_exponent <= 32'h7fffffff;
				end
				else
				begin
					c1_exponent <= {1'b0, dataa[WIDTH-2:WIDTH-12]} - 12'd1023;
				end
			end			
		end
	end
	
	assign c1_stall = stall_in;
	assign valid_out = c1_valid;
	assign result = c1_exponent;	
	
endmodule