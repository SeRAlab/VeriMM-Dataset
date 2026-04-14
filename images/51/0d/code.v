module top_module(o_data, i_data);input	 [13:0] i_data;
  
  output [31:0]o_data;

  
  assign o_data = {{(31-13){i_data[13]}}, i_data};
	
endmodule