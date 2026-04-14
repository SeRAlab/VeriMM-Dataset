module top_module(output_data, input_data0, input_data1, select);parameter word_size = 5;


input select;
input [word_size-1:0] input_data0, input_data1;


output reg [word_size-1:0] output_data;


always @(select or input_data0 or input_data1) begin
	case (select)
		0: output_data <= input_data0;
		1: output_data <= input_data1;
		default: output_data <= 0;
	endcase
end

endmodule