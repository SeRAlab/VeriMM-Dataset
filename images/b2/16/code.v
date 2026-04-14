module top_module(
    input EX_MEM_regwrite,
    input [4:0] EX_MEM_writereg,
    input [4:0] ID_EX_reg1,
    input [4:0] ID_EX_reg2,
    input MEM_WB_regwrite,
    input [4:0] MEM_WB_writereg,
    output [1:0] ALUselA,
    output [1:0] ALUselB
    );wire ex1;
	 wire ex2;
	 wire con1;
	 wire con2;
	 reg [1:0] a1;
	 reg [1:0] a2;
	 assign ALUselA = a1;
	 assign ALUselB = a2;
	 assign ex1 = EX_MEM_regwrite && (EX_MEM_writereg!=0) && (EX_MEM_writereg == ID_EX_reg1);
	 assign ex2 = EX_MEM_regwrite && (EX_MEM_writereg!=0) && (EX_MEM_writereg == ID_EX_reg2);
	 assign con1 = MEM_WB_regwrite && (MEM_WB_writereg!=0) && (MEM_WB_writereg == ID_EX_reg1) && !ex1;
	 assign con2 = MEM_WB_regwrite && (MEM_WB_writereg!=0) && (MEM_WB_writereg == ID_EX_reg2)&&!ex2;
	 always@*
	 begin
	 if(ex1)
	 a1 = 01;
	 else if(con1)
	 a1 = 10;
	 else 
	 a1 = 00;
	 if(ex2)
	 a2 = 01;
	 else if(con2)
	 a2 = 10;
	 else
	 a2 = 00;
	 end
	 
endmodule