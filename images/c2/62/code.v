module adder_subtractor(a, b, sub, result, carry_out);
	input [3:0] a, b;
	input sub;
	output [3:0] result;
	output carry_out;
	
	reg [3:0] twos_comp_b;
	reg [4:0] temp_result;
	
	assign twos_comp_b = ~b + 1;
	
	always @(*) begin
		if (sub) begin
			temp_result = a + twos_comp_b;
			carry_out = temp_result[4];
			result = temp_result[3:0];
		end
		else begin
			temp_result = a + b;
			carry_out = temp_result[4];
			result = temp_result[3:0];
		end
	end
	
endmodule