module top_module(A, B, value_result_tens, value_result_units, sign_result, KEY_IN, clk, reset_n, operator);output [3:0] value_result_tens;
	output [3:0] value_result_units;
	output [3:0] A;
	output [3:0] B;
	output sign_result;
	input [1:0] operator;
	input [3:0] KEY_IN;
	input reset_n;
	input clk;
	
	
	reg [3:0] next_A, next_B, next_ten, next_unit;
	reg slt;
	reg next_sign;
	reg tmpIn;
	
	
	always @(posedge clk) begin
		if (!reset_n) begin
			next_A <= 0;
			next_B <= 0;
			next_ten <= 0;
			next_unit <= 0;
			next_sign <= 0;
			slt <= 0;
		end else begin
			if (KEY_IN == 4'hA) begin
				slt <= 0;
			end else if (KEY_IN == 4'hB) begin
				slt <= 1;
			end else begin
				if (slt == 0) begin
					next_A <= KEY_IN;
				end else begin
					next_B <= KEY_IN;
				end
			end
			if (operator[0] == 0) begin
				if (A+B >= 10) begin
					next_ten <= 1;
					next_unit <= A + B - 10;
				end else begin
					next_ten <= 0;
					next_unit <= A + B;
				end
				next_sign <= 0;
			end else if (operator[1] == 0) begin
				if (A > B || A == B) begin
					{next_ten, next_unit} <= A - B;
					next_sign <= 0;
				end else begin
					{next_ten, next_unit} <= B - A;
					next_sign <= 1;
				end
			end else begin
				{next_ten, next_unit} <= {next_ten, next_unit};
			end
		end
	end
	assign A = next_A;
	assign B = next_B;
	assign value_result_tens = next_ten;
	assign value_result_units = next_unit;
	assign sign_result = next_sign;
	
	
								
	
endmodule