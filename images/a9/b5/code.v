module top_module(data_in, data_out);parameter width = 3;
   
   parameter [0:width-1] min_value = 0;
   parameter [0:width-1] max_value = (1 << width) - 1;
   
   localparam num_values = max_value - min_value + 1;
   
   // Using a function to calculate the ceiling of log base 2
   function integer clogb(input integer value);
       begin
           if (value <= 1) clogb = 0;
           else begin
               clogb = 0;
               while (2 ** clogb < value) begin
                   clogb = clogb + 1;
               end
           end
       end
   endfunction
   
   localparam cwidth = clogb(num_values);
   
   // operand inputs
   input [0:width-1] data_in;
   
   // sum output
   output [0:width-1] data_out;
   wire [0:width-1] data_out;
   
   wire 	    carry;
   assign carry = &data_in[(width-cwidth):width-1];
   
   wire 	    wrap;
   assign wrap = (data_in[(width-cwidth):width-1] ==
		  max_value[(width-cwidth):width-1]);
   
   generate
      
      if((1 << cwidth) == num_values)
	begin
	   
	   // if the range is a power of two, we can take advantage of natural
	   // wraparound for the LSBs
	   assign data_out[(width-cwidth):width-1]
		    = data_in[(width-cwidth):width-1] + 1'b1;
	   
	end
      else
	begin
	   
	   // if the range is not a power of two, we need to implement 
	   // explicit wraparound
	   assign data_out[(width-cwidth):width-1]
		    = wrap ?
		      min_value[(width-cwidth):width-1] :
		      (data_in[(width-cwidth):width-1] + 1'b1);
	   
	end
      
      if(width > cwidth)
	begin
	   
	   if(min_value[0:(width-cwidth)-1] == max_value[0:(width-cwidth)-1])
	     begin
		
		// if the MSBs are identical for the first and last value, we 
		// never need to change them
		assign data_out[0:(width-cwidth)-1]
			 = data_in[0:(width-cwidth)-1];
		
	     end
	   else
	     begin
		
		// if the first and last value have differing MSBs, we need to
		// adjust them whenever either the LSBs overflow or wraparound
		// occurs
		assign data_out[0:(width-cwidth)-1]
			 = data_in[0:(width-cwidth)-1] + carry - wrap;
		
	     end
	   
	end
      
   endgenerate
   
endmodule