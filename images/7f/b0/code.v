module top_module(inputValue, shiftNum, shifted);input [31:0] inputValue;
	input [4:0] shiftNum;
	output [31:0] shifted;
	
	wire signed [31:0] barrel_bus [4:0];
	
	assign barrel_bus[4] = shiftNum[4] ? (inputValue >>> 16) : inputValue;
	assign barrel_bus[3] = shiftNum[3] ? (barrel_bus[4] >>> 8) : barrel_bus[4];
	assign barrel_bus[2] = shiftNum[2] ? (barrel_bus[3] >>> 4) : barrel_bus[3];
	assign barrel_bus[1] = shiftNum[1] ? (barrel_bus[2] >>> 2) : barrel_bus[2];
	assign barrel_bus[0] = shiftNum[0] ? (barrel_bus[1] >>> 1) : barrel_bus[1];
	assign shifted = barrel_bus[0];endmodule