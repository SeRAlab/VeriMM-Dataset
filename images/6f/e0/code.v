module top_module(
input clk,
input reset,
input [31:0] value0,
input [31:0] value1,
input [31:0] value2,
input [31:0] value3,
input [31:0] value4,
input [31:0] value5,
input [31:0] value6,
input [31:0] value7,
input [31:0] value8,
input caculating_start,
output caculating_done,
input res_done,
output [31:0] ret
);parameter kernel0 = 8'd1;
	parameter kernel1 = 8'd2;
	parameter kernel2 = 8'd3;
	parameter kernel3 = 8'd4;
	parameter kernel4 = 8'd5;
	parameter kernel5 = 8'd6;
	parameter kernel6 = 8'd7;
	parameter kernel7 = 8'd8;
	parameter kernel8 = 8'd9;
	
	reg [31:0] Add0,Add1,Add2,Add3,Add4,Add5,Add6,Add7,Add8;

	
	reg status;
	reg [31:0] Dout;
	assign ret = Dout;
	reg reg_caculating_done;
	assign caculating_done = reg_caculating_done;
	
	always @(posedge clk) begin
		if (reset) begin
			status <= 1'b0;
		end else if (status == 1'b0 && caculating_start) begin
			Add0 <= value0 * kernel0;
			Add1 <= value1 * kernel1;
			Add2 <= value2 * kernel2;
			Add3 <= value3 * kernel3;
			Add4 <= value4 * kernel4;
			Add5 <= value5 * kernel5;
			Add6 <= value6 * kernel6;
			Add7 <= value7 * kernel7;
			Add8 <= value8 * kernel8;
			status <= 1'b1;
		end else if (status == 1'b1 && caculating_start) begin
			Dout <= Add0+Add1+Add2+Add3+Add4+Add5+Add6+Add7+Add8;
			status <= 1'b0;
			reg_caculating_done <= 1'b1;
		end else if (res_done) begin
			reg_caculating_done <= 1'b0;
		end
	end 

endmodule