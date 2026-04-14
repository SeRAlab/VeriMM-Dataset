module top_module(out,clk);input clk;


   output [31:0] out ;

   wire [63:0]out_64 ;
 
   reg [63:0] 	 z=0 ;

   always@(posedge clk) begin
   
      z= z+ 64'h9e3779b97f4a7c15 ;
      z = (z ^ (z >> 30)) * 64'hbf58476d1ce4e5b9;
	z = (z ^ (z >> 27)) * 64'h94d049bb133111eb;
   end

   assign out_64 = z^(z>>31);
   assign out=out_64[63:32] ;
endmodule