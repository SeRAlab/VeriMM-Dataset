module top_module(clock, resetn, dataa, datab, enable, result);input clock, resetn;
	input [31:0] dataa;
	input [31:0] datab;
	input enable;
	output [31:0] result;
	
	
	wire [7:0] exponent_in = dataa[30:23];
	wire [22:0] mantissa_in = dataa[22:0];
	wire sign_in = dataa[31];
	wire [31:0] shift_in = datab;
	wire [31:0] intermediate_exp = shift_in + exponent_in;
	
	reg [7:0] exp_stage_1;
	reg [22:0] man_stage_1;
	reg sign_stage_1;
	
	always@(posedge clock or negedge resetn)
	begin
		if (~resetn)
		begin
			exp_stage_1 <= 8'dx;
			man_stage_1 <= 23'dx;
			sign_stage_1 <= 1'bx;
		end
		else if (enable)
		begin
			sign_stage_1 <= sign_in;
			if (exponent_in == 8'hff)
			begin
			   
				man_stage_1 <= mantissa_in;
				exp_stage_1 <= exponent_in;
			end
			else
		   if (intermediate_exp[31] | (exponent_in == 8'd0))
			begin
				man_stage_1 <= 23'd0;
				exp_stage_1 <= 8'd0;
			end
			else if ({1'b0, intermediate_exp[30:0]} >= 255)
			begin
				
				man_stage_1 <= 23'd0;
				exp_stage_1 <= 8'hff;				
			end
			else if (intermediate_exp[7:0] == 8'd0)
			begin
				
				man_stage_1 <= 23'd0;
				exp_stage_1 <= 8'h00;				
			end			
			else
			begin
				man_stage_1 <= mantissa_in;
				exp_stage_1 <= intermediate_exp[7:0];
			end
		end
	end
	
	assign result = {sign_stage_1, exp_stage_1, man_stage_1};
endmodule