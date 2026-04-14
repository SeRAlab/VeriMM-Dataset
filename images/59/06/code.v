module top_module(input1, input2, select, inst, output1);input [31:0] input1, input2, inst;
input select;
output reg [31:0] output1;

always @(*)
	begin
	if(inst[6:0] === 7'b1100011)
		begin
		case(select)
		1'b0:	begin
			output1 <= input1;		
			end
		1'b1:
			begin
			output1 <= input2;
			end
		endcase
		end
	else
		output1 <= input1;
	end
endmodule