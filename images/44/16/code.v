module top_module(input wrEnable, input [4:0] wrReg, input [31:0] wrData, input [4:0] rdReg1, output [31:0] rdData1, input [4:0] rdReg2, output [31:0] rdData2, input clk);reg [31:0] regFile [31:0];

	assign rdData1 = regFile[rdReg1];
	assign rdData2 = regFile[rdReg2];

	always @(posedge clk) begin if (wrEnable) begin regFile[wrReg] <= wrData; end end

endmodule