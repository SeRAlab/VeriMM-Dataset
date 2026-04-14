module top_module(
input Clk,
input Reset,
input[7:0] Instr_Code,
output reg [7:0] IF_ID_Instr_Code
    );always @ (posedge Clk, negedge Reset)
 begin
	 if(Reset == 0)
	 begin
		 IF_ID_Instr_Code <= 0;
	 end
	 
	 else
	 begin
		 IF_ID_Instr_Code <= Instr_Code;
	 end
 end
endmodule