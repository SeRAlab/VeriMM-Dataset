module top_module(
		input clock,
		input reset,
		input syncClr,
		input [4:0] rs,
		input [4:0] rt,
		input [4:0] rd,
		input [4:0] sa,
		input [3:0] aluOperation,
		input [31:0] sigExt,
		input [31:0] readData1,
		input [31:0] readData2,
		input aluSrc,
		input aluShiftImm,
		input regDst,
		input loadImm,
		input [3:0]memWrite,
		input memToReg,
		input[1:0] memReadWidth,
		input regWrite,
		
		output reg [3:0] aluOperationOut,
		output reg [31:0] sigExtOut,
		output reg [31:0] readData1Out,
		output reg [31:0] readData2Out,
		output reg aluSrcOut,
		output reg aluShiftImmOut,
		output reg [3:0]memWriteOut,
		output reg memToRegOut,
		output reg[1:0] memReadWidthOut,
		output reg[4:0] rsOut,
		output reg[4:0] rtOut,
		output reg[4:0] rdOut,
		output reg[4:0] saOut,
		output reg regDstOut,
		output reg loadImmOut,
		output reg regWriteOut
    );always @(negedge clock,posedge reset)begin
		if(reset)begin
			 aluOperationOut<=0;
			 sigExtOut<=0;
			 readData1Out<=0;
			 readData2Out<=0;
			 aluSrcOut<=0;
			 aluShiftImmOut<=0;
			 memWriteOut<=0;
			 memToRegOut<=0;
			 memReadWidthOut<=0;
			 regWriteOut<=0;
			 rsOut<=0;
			 rtOut<=0;
		    rdOut<=0;
			 saOut<=0;
			 regDstOut<=0;
			 loadImmOut<=0;
		end
		else if(syncClr)begin
			 aluOperationOut<=0;
			 sigExtOut<=0;
			 readData1Out<=0;
			 readData2Out<=0;
			 aluSrcOut<=0;
			 aluShiftImmOut<=0;
			 memWriteOut<=0;
			 memToRegOut<=0;
			 memReadWidthOut<=0;
			 regWriteOut<=0;
			 rsOut<=0;
			 rtOut<=0;
		    rdOut<=0;
			 saOut<=0;
			 regDstOut<=0;
			 loadImmOut<=0;
		end
		else begin
			 aluOperationOut<=aluOperation;
			 sigExtOut<=sigExt;
			 readData1Out<=readData1;
			 readData2Out<=readData2;
			 aluSrcOut<=aluSrc;
			 aluShiftImmOut<=aluShiftImm;
			 memWriteOut<=memWrite;
			 memToRegOut<= memToReg;
			 memReadWidthOut<=memReadWidth;
			 regWriteOut<=regWrite;
			 rsOut<=rs;
			 rtOut<=rt;
		    rdOut<=rd;
			 saOut<=sa;
			 regDstOut<=regDst;
			 loadImmOut<=loadImm;
		end
		
	 end


endmodule