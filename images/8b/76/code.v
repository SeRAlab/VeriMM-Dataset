module top_module(data_in, data_out);parameter width = 8;
   
   
   input [0:width-1] data_in;
   
   
   output [0:width-1] data_out;
   wire [0:width-1]   data_out;
   
   generate
      
      if(width == 1)
	assign data_out = data_in;
      else
	begin
	   
	   genvar 		 pos;
	   
	   for(pos = 0; pos < width; pos = pos + 1)
	     begin:poss
		
		wire [0:(width-1)-1] others;
		
		if(pos > 0)
		  assign others[0:pos-1] = data_in[0:pos-1];
		if(pos < (width - 1))
		  assign others[pos:(width-1)-1] = data_in[(pos+1):width-1];
		
		assign data_out[pos] = data_in[pos] & ~|others;
		
	     end
	   
	end
      
   endgenerate
   
endmodule