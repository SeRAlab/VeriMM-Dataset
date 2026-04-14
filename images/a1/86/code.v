module top_module(
 	input clk,
 	input cl,
  input up,
  input w,
  input [31:0] d,
 	output reg [31:0] q
     );always @(posedge clk)
 	begin
   	if (cl == 1)
   		q<=0;
   	else if(w == 1)
      q<=d;
    else
   		if(up == 1)
   			q<=q+1;
 	end


 endmodule