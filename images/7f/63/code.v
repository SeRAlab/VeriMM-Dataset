module top_module(
	data1_i,
	data2_i,
	ALUCtrl_i,
	data_o, 
	Zero_o 
);input [31:0] data1_i;
input [31:0] data2_i;
input [3:0] ALUCtrl_i;
output reg [31:0] data_o;
output Zero_o; 

parameter ALUCtrl_add = 4'b0010;
parameter ALUCtrl_sub = 4'b0110;
parameter ALUCtrl_and = 4'b0000;
parameter ALUCtrl_or = 4'b0001;
parameter ALUCtrl_mul = 4'b0111; 

assign Zero_o = (data_o == 32'b0)? 1'b1:1'b0; 

always @(*) begin
	case(ALUCtrl_i)
		ALUCtrl_add: data_o <= data1_i + data2_i;
		ALUCtrl_sub: data_o <= data1_i - data2_i;
		ALUCtrl_and: data_o <= data1_i & data2_i;
		ALUCtrl_or: data_o <= data1_i | data2_i;
		ALUCtrl_mul: data_o <= data1_i * data2_i;
		default: data_o <= data1_i + data2_i;
	endcase
end

endmodule