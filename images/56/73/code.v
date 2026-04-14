module top_module(
		input clock,
		input reset,
		input [4:0] writeRegister,
		input [31:0] aluOut,
		input [31:0] memoryOut,
		input regWrite,
		input memToReg,
		
		output reg [4:0] writeRegisterOut,
		output reg [31:0] aluOutOut,
		output reg [31:0] memoryOutOut,
		output reg regWriteOut,
		output reg memToRegOut
    );always @(negedge clock,posedge reset)begin
		if(reset)begin
			writeRegisterOut<=0;
			aluOutOut<=0;
			memoryOutOut<=0;
			regWriteOut<=0;
			memToRegOut<=0;
		end
		else begin
			writeRegisterOut<=writeRegister;
			aluOutOut<=aluOut;
			memoryOutOut<=memoryOut;
			regWriteOut<=regWrite;
			memToRegOut<=memToReg;
		end
		
	 end


endmodule