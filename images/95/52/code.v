module top_module(input_data, output_data);input [31:0] input_data;
	output [63:0] output_data;

	wire Sign;
	assign  Sign = input_data[30] ? input_data[20] : input_data[23];
	assign  output_data = input_data[30] ? ({{55{Sign}}, input_data[20:12]}) : ({{45{Sign}}, input_data[23:5]});	
    
endmodule