module top_module(opA,opB,sum,dsp_sel,out);input [3:0] opA,opB;
	input [4:0] sum;
	input [1:0] dsp_sel;
	output [3:0] out;

	reg [3:0] out;
	reg [3:0] temp_out;
	reg [3:0] opA_out;
	reg [3:0] opB_out;
	reg [3:0] sum_out;
	reg [3:0] cout_out;

	always @ (sum)
		begin
			if (sum[4] == 1)
				cout_out <= 4'b0001;
			else
				cout_out <= 4'b0000;
		end

	always @ (opA)
		begin
			opA_out <= opA;
		end

	always @ (opB)
		begin
			opB_out <= opB;
		end

	always @ (sum)
		begin
			sum_out <= sum[3:0];
		end

	always @ (dsp_sel, sum_out, cout_out, opB_out, opA_out)
		begin
			case (dsp_sel)
				2'b00: temp_out = sum_out;
				2'b01: temp_out = cout_out;
				2'b10: temp_out = opB_out;
				2'b11: temp_out = opA_out;
			endcase
			out <= temp_out;
		end

endmodule