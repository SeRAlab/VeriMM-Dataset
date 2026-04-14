module top_module(clk , input_data_1, input_data_2, output_data);input clk;
    parameter n = 64;
	input [n - 1 : 0] input_data_1, input_data_2;
	output reg [n - 1 : 0] output_data;

    always @(input_data_1)
    begin
        output_data = input_data_1 + input_data_2;
    end
endmodule