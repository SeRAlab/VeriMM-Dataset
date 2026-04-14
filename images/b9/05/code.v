module top_module(
	input  [32-1:0] data0_i,       
	input  [32-1:0] data1_i,
	input       	select_i,
	output reg [32-1:0] data_o
               );always@(*)
begin

	case(select_i)
	
	1'b0 : data_o = data0_i;

	1'b1 : data_o = data1_i;
	
	endcase



end

endmodule