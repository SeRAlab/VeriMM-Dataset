module top_module(data_i, data_o, single);parameter op_bits = 32;
   input [op_bits -1:0] data_i;
   output [31:0] data_o;
   input single;

   
   
   generate
      if (op_bits == 32) begin : general_case
         assign data_o = data_i;
	 
	 
	 assign imp = single;
	 
         end
      else begin : special_case
         assign data_o = {{(32 -op_bits){1'b0}},data_i};
	 
	 assign imp = single;
	 
         end
   endgenerate
endmodule