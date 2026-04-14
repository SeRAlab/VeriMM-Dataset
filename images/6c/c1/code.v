module top_module(data,b,result);input  [15:0]     data; 
   input  [15:0]     b; 
   output [15:0]     result;    
   assign result = data << b;
endmodule