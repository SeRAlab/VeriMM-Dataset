module top_module(
input clock,reset,
input [4:0] phasecounter,

input MemtoReg, RegWrite,

input [15:0] ALUResult,data,

input [2:0] des,

output reg out_MemtoReg, out_RegWrite,
output reg [15:0] out_ALUResult,out_data,
output reg [2:0] out_des

);always @(posedge clock or negedge reset)
begin
	if(reset == 1'b0)
		begin
			{out_MemtoReg, out_RegWrite} <= 2'b00;
			out_ALUResult <= 16'b0;
			out_data <= 16'b0;
			out_des <= 3'b0;
		end 
	else if(phasecounter[3] == 1'b1)
		begin
			{out_MemtoReg, out_RegWrite} <= {MemtoReg, RegWrite};
			out_ALUResult <= ALUResult;
			out_data <= data;
			out_des <= des;
		end
end

endmodule