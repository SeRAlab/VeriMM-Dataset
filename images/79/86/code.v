module top_module(
   
   out,
   
   clk, reset, enable
   );input clk;
   input reset;
   output [7:0] out ;
   input 	enable ;

   reg [7:0] 	out ;

   always @(posedge clk or posedge reset)
     if ( reset )
       out <= 4'b1111;

     else
       if ( enable )
	 out <= {out[6:4],(out[7]^out[3]),(out[7]^out[2]),(out[7]^out[1]),out[0],out[7]};endmodule