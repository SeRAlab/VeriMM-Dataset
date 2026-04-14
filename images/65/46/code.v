module top_module(
	data1_i,
	data2_i,
	ALUCtrl_i,
	data_o,
	Zero_o
);`define ADD 3'b000
`define SUB 3'b001
`define AND 3'b010
`define OR  3'b011
`define MUL 3'b101

input [31:0] data1_i;
input [31:0] data2_i;
input [2:0] ALUCtrl_i;
output reg [31:0] data_o;
output reg Zero_o;

always@(*)begin
	case(ALUCtrl_i)
		`ADD: begin
			data_o = data1_i + data2_i;
		end
		`SUB: begin
			data_o = data1_i - data2_i;
		end
		`AND: begin
			data_o = data1_i & data2_i;
		end
		`OR: begin
			data_o = data1_i | data2_i;
		end
		`MUL: begin
			data_o = data1_i * data2_i;
		end
	endcase
	Zero_o = (data_o == 32'b0)? 1:0;
end


endmodule