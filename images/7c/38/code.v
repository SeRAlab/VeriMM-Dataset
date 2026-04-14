module top_module(clk, Reset, RegWriteE, RegWriteM, MemtoRegE,
		 MemtoRegM, MemWriteE, MemWriteM, ALUOutE, ALUOutM,
		 WriteDataE, WriteDataM, WriteRegE, WriteRegM);input clk, Reset,  RegWriteE, MemtoRegE, MemWriteE;
  input [31:0] WriteRegE, WriteDataE, ALUOutE;
  
  output reg RegWriteM, MemtoRegM, MemWriteM;
  output reg [31:0] WriteRegM, WriteDataM, ALUOutM;

  always @ (posedge clk) 
  begin
    if (Reset) 
	 begin
			RegWriteM <= 0;
			MemtoRegM <= 0;
			MemWriteM <= 0;
			WriteRegM <= 0;
			WriteDataM <= 0;
			ALUOutM <= 0;
    end
    else 
	 begin
			RegWriteM <= RegWriteE;
			MemtoRegM <= MemtoRegE;
			MemWriteM <= MemWriteE;
			WriteRegM <= WriteRegE;
			WriteDataM <= WriteDataE;
			ALUOutM <= ALUOutE;
    end
  end
endmodule