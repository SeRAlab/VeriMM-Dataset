module top_module(Out, In, Reset, Clk, Load, Increment);parameter SIZE=4;
input Increment;
input [SIZE-1:0]In;
input Reset, Clk, Load;
output [SIZE-1:0]Out;
reg [SIZE-1:0]Out;

always @ (posedge Clk or negedge Reset)
	if(!Reset)
		Out = 0;
	else 
	 begin
     if (Increment) 
	   	Out = Out +1;
	 if(Load)
			Out = In;
      end
endmodule