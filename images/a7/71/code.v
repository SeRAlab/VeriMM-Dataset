module top_module(data_in, data_out);parameter width = 32;
   
   
   parameter pad_left = 0;
   
   
   parameter pad_left_value = 0;
   
   
   parameter pad_right = 0;
   
   
   parameter pad_right_value = 0;
   
   
   localparam new_width = pad_left + width + pad_right;
   
   
   input [0:width-1] data_in;
   
   
   output [0:new_width-1] data_out;
   wire [0:new_width-1] data_out;
   
   genvar 		i;
   
   generate
      
      for(i = 0; i < new_width; i = i + 1)
	begin:bits
	   
	   if(i < pad_left)
	     assign data_out[i] = pad_left_value;
	   else if(i >= (new_width - pad_right))
	     assign data_out[i] = pad_right_value;
	   else
	     assign data_out[i] = data_in[i - pad_left];
	   
	end
      
   endgenerate
   
endmodule