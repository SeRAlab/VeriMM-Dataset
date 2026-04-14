module top_module(input [3:0] input_data, output [3:0] output_data);wire [3:0] inverted_data;
  
  assign inverted_data = ~input_data;
  assign output_data = inverted_data;
endmodule