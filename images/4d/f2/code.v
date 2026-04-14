module top_module(inp, res);parameter signed [31:0]  old_width = 4;
   parameter signed [31:0]  new_width = 2;
   input [old_width - 1 : 0] inp;
   output [new_width - 1 : 0] res;

   wire [new_width-1:0] result;

   assign res = result;

   generate
     if (new_width > old_width)
       begin:u0
	  assign result = { {(new_width-old_width){inp[old_width-1]}}, inp};
       end 
     else
       begin:u1
	  assign result[new_width-1:0] = inp[new_width-1:0];
       end 
   endgenerate
   
endmodule