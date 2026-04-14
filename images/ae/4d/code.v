module top_module(	
	data1_i,
	data2_i,
	ALUCtrl_i,
	data_o

);input  [31:0] 	data1_i, data2_i;
input  [2:0] 	ALUCtrl_i;
output [31:0] 	data_o;



reg [7:0] sum;


	always@(data1_i or data2_i or ALUCtrl_i)begin 
		case(ALUCtrl_i)
			3'b001: sum = data1_i + data2_i;
			3'b010: sum = data1_i - data2_i;
			3'b011: sum = data1_i & data2_i;
			3'b100: sum = data1_i | data2_i;
			3'b101: sum = data1_i ^ data2_i;
			3'b110: sum = data1_i * data2_i;
			default: sum = data1_i;
		endcase
	end
assign data_o = sum;


endmodule