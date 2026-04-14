module multiplexer (
	input sel,
	input [15:0] data0,
	input [15:0] data1,
	output reg [15:0] data_out);always @(*) begin
		case (sel)
			1'b0: data_out <= data0;
			1'b1: data_out <= data1;
		endcase
	end
	
endmodule