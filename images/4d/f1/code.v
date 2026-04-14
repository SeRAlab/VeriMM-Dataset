module top_module(CLK, RESET, LOAD, DATA, INC, COUNT);parameter WIDTH = 4;
   input CLK, RESET, LOAD, INC;
   input [WIDTH-1:0] DATA;
   output [WIDTH-1:0] COUNT;
   reg [WIDTH-1:0] 	  COUNT;
   wire [WIDTH-1:0]   COUNT_MUX_OUT;
   
   integer i;

   function [WIDTH-1:0] COUNT_FUNC;
	  input LOAD, INC;
	  input [3:0] DATA,COUNT;

	  if(LOAD)
		COUNT_FUNC = DATA;
	  else if(INC)
		COUNT_FUNC = COUNT_FUNC + 1;
	  else
		COUNT_FUNC = COUNT_FUNC - 1;
   endfunction

   assign COUNT_MUX_OUT = COUNT_FUNC(LOAD, INC, DATA, COUNT);
   
   always @(posedge CLK or posedge RESET) begin
      if(RESET)
        for(i=0;i<=WIDTH-1;i=i+1)
          COUNT[i] <= 0;
      else 
        COUNT <= COUNT_MUX_OUT;
   end
   
endmodule