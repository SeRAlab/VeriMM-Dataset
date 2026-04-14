module top_module(
	pc,
	rs1,
	asel,
	alumux1_out
);parameter DATA_WIDTH = 32;

  
  
  
	input [14 : 0]						 pc;
	input [DATA_WIDTH - 1 : 0] rs1;
	input											 asel;
	output [DATA_WIDTH - 1 : 0] alumux1_out;

  
  
  
	reg [DATA_WIDTH - 1 : 0] alu_reg;

  
  
  
	always @ (*) begin
		case (asel)
			1'b0: 		alu_reg = rs1;
			1'b1: 		alu_reg = pc;
			default: 	alu_reg = 'hz;
		endcase
	end

  
  
  
	assign alumux1_out = alu_reg;

endmodule