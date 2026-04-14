module top_module(data_in, data_out);parameter num_ports = 2;
   
   
   parameter width = 1;
   
   
   input [0:width*num_ports-1] data_in;
   
   
   output [0:width-1] data_out;
   wire [0:width-1] data_out;
   
   generate
      
      genvar 	    i;
      for(i = 0; i < width; i = i + 1)
	begin:bit_positions
	   
	   wire [0:num_ports-1] data;
	   
	   genvar 		j;
	   for(j = 0; j < num_ports; j = j + 1)
	     begin:input_ports
		assign data[j] = data_in[j*width+i];
	     end
	   
	   assign data_out[i] = ^data;
	   
	end
      
   endgenerate
   
endmodule