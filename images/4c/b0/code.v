module top_module(clock, resetn, dataa, datab, valid_in, valid_out, stall_in, stall_out, result);input clock, resetn;
	input [63:0] dataa;
	input [31:0] datab;
	input valid_in, stall_in;
	output valid_out, stall_out;
	output [63:0] result;
	
	
	wire [10:0] exponent_in = dataa[62:52];
	wire [51:0] mantissa_in = dataa[51:0];
	wire sign_in = dataa[63];
	wire [31:0] shift_in = datab;
	wire [31:0] intermediate_exp = shift_in + {1'b0, exponent_in};
	
	reg [10:0] exp_stage_1;
	reg [51:0] man_stage_1;
	reg sign_stage_1;
	reg stage_1_valid;
	wire enable_stage_1;
	
	always@(posedge clock or negedge resetn)
	begin
		if (~resetn)
		begin
			exp_stage_1 <= 11'dx;
			man_stage_1 <= 52'dx;
			sign_stage_1 <= 1'bx;
			stage_1_valid <= 1'b0;
		end
		else if (enable_stage_1)
		begin
			stage_1_valid <= valid_in;
			sign_stage_1 <= sign_in;
			if (exponent_in == 11'h7ff)
			begin
			   
				man_stage_1 <= mantissa_in;
				exp_stage_1 <= exponent_in;
			end
			else
		  if (intermediate_exp[31] | (exponent_in == 11'd0))
			begin
        
				man_stage_1 <= 52'd0;
				exp_stage_1 <= 11'd0;
			end
			else if ({1'b0, intermediate_exp[30:0]} >= 12'h7ff)
			begin
				
				man_stage_1 <= 52'd0;
				exp_stage_1 <= 11'h7ff;				
			end
			else if (intermediate_exp[10:0] == 11'd0)
			begin
				
        
				man_stage_1 <= 52'd0;
				exp_stage_1 <= 11'd0;				
			end			
			else
			begin
				man_stage_1 <= mantissa_in;
				exp_stage_1 <= intermediate_exp[10:0];
			end
		end
	end
	
	assign enable_stage_1 = ~stage_1_valid | ~stall_in;
	assign valid_out = stage_1_valid;
	assign stall_out = stage_1_valid & stall_in;
	assign result = {sign_stage_1, exp_stage_1, man_stage_1};
endmodule