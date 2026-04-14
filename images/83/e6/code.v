module top_module(input [0:width-1] data_in,
   output [0:width-1] data_out);// input data width
   parameter width = 8;
   
   // number of blocks in input data
   parameter num_blocks = 2;
   
   // width of each block
   localparam step = width / num_blocks;
   
   // vector of output data
   // Removed the wire declaration for data_out since it's already declared as an output port.
   
   generate
      
      genvar 	    i;
      for(i = 0; i < step; i = i + 1)
	begin:blocks
	   
	   genvar j;
	   for(j = 0; j < num_blocks; j = j + 1)
	     begin:bits
		assign data_out[i*num_blocks+j] = data_in[i+j*step];
	     end
	   
	end
      
   endgenerate
   
endmodule