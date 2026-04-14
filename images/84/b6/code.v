module multiplexer (
	input [1:0] sel,
	input [7:0] data0,
	input [7:0] data1,
	input [7:0] data2,
	input [7:0] data3,
	output reg [7:0] data_out);always @(*) begin
		case (sel)
			2'b00: data_out <= data0;
			2'b01: data_out <= data1;
			2'b10: data_out <= data2;
			2'b11: data_out <= data3;
		endcase
	end
	
endmodule