module top_module(
    input [31:0] instruccion,
	 input [10:0] pc,
	 input clock,
	 input IF_ID_Write,
	 output [31:0] salida_inst,
	 output [10:0] salida_pc
	 );reg  [31:0] out_inst = 0;
	reg  [10:0] out_pc = 0;
	
	always @(negedge clock)
	begin
		if(IF_ID_Write)
			out_inst = instruccion;
			out_pc = pc;
	end
	
	assign salida_inst = out_inst;
	assign salida_pc = out_pc;
	
endmodule