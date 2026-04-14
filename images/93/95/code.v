module top_module(S,V,N,ALUFun,in1,in2,Sign);input V,N,Sign;
input [2:0] ALUFun;
input [31:0] in1,in2;
output [31:0] S;

wire EQ,NEQ,LT,LEZ,LTZ,GTZ;
assign EQ=in1==in2;
assign NEQ=~(in1==in2);
assign LT=(~V&N)|(V&in1[31]);
assign EQZ=(in1==0);
assign LEZ=Sign?(in1[31]||EQZ):EQZ;
assign LTZ=Sign?(in1[31]):0;
assign GTZ=Sign?(~in1[31]):~EQZ;

assign S=(ALUFun[2]==0)?
			(
			(ALUFun[1]==0)?
				((ALUFun[0]==0)?NEQ:EQ)
				:
				((ALUFun[0]==0)?LT:0)
			)
			:
			(
			(ALUFun[1]==0)?
				((ALUFun[0]==0)?0:LTZ)
				:
				((ALUFun[0]==0)?LEZ:GTZ)
			);endmodule