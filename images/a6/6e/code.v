module top_module(output wire [2:0] value);parameter select = 0;

   case (select)
     0: begin
	function [2:0] funfun;
	   input integer in;
	   funfun = in;
	endfunction 

	assign value = funfun(select);
     end
     1: begin
	function [2:0] funfun;
	   input integer in;
	   funfun = in;
	endfunction 

	assign value = funfun(1);
     end
     2: assign value = 2;
     3: assign value = 3;
     default:
       assign value = 7;
   endcase 

endmodule