module top_module(sck, rst, add1, init_val, count);parameter SIZE = 13;
      
   input sck;
   input rst;
   input add1;
   input [SIZE-1:0] init_val;   
   
   output reg [SIZE-1:0] count = 0;

   always @(posedge sck)
     if(rst)
       count = init_val;
     else
       begin
	  if(add1)
	    count = count + 1'b1;
	  else
	    count = count;
       end

endmodule