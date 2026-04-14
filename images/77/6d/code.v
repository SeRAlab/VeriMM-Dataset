module top_module(clk, reset, enable, data_in, data_out);// width of register
   parameter width = 32;
   
   // depth of register (number of levels)
   parameter depth = 2;
   
   parameter reset_type = 1;
   
   input clk;
   input reset;
   
   // perform shift
   input enable;
   
   // data input
   input [0:width-1] data_in;
   
   // data output
   output [0:width-1] data_out;
   reg [0:width-1] data_out; // Change to reg type for output
   
   genvar level;
   
   reg [0:(depth+1)*width-1] data; // Change to reg type for internal data
   assign data[0:width-1] = data_in;
   
   generate
      
      for(level = 0; level < depth; level = level + 1)
      begin:levels
         
         reg [0:width-1] data_q; // Change to reg type for data_q
         wire [0:width-1] data_s;
         
         assign data_s = enable ? data[level*width:(level+1)*width-1] : data_q;
         
         always @(posedge clk or negedge reset)
           if (!reset)
             data_q <= 0;
           else
             data_q <= data_s;
         
         assign data[(level+1)*width:(level+2)*width-1] = data_q;
         
      end
      
   endgenerate
   
   assign data_out = data[depth*width:(depth+1)*width-1];
   
endmodule