module top_module(
	input [1:0] select,
	input [31:0] A,
	input [31:0] B,
	output [1:0] EPC,
	output [31:0] mfhi,
	output [31:0] mflo
);always@ (*) begin
	if(select == 2'b01)begin
		
	end
	if(select == 2'b10)begin
		
	end
end
endmodule