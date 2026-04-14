module top_module( clock, reset, enable, xi,yi,zi,constant,xo,yo,zo);parameter bitwidth = 16;
   parameter zwidth = 16;
   parameter shift = 1;
   
   input     clock;
   input     reset;
   input     enable;
   input [bitwidth-1:0] xi,yi;
   input [zwidth-1:0] zi;
   input [zwidth-1:0] constant;
   output [bitwidth-1:0] xo,yo;
   output [zwidth-1:0] zo;
   
   wire z_is_pos = ~zi[zwidth-1];

   reg [bitwidth-1:0] 	 xo,yo;
   reg [zwidth-1:0] zo;
   
   always @(posedge clock)
     if(reset)
       begin
	  xo <= #1 0;
	  yo <= #1 0;
	  zo <= #1 0;
       end
     else if(enable)
       begin
	  xo <= #1 z_is_pos ?   
		xi - {{shift+1{yi[bitwidth-1]}},yi[bitwidth-2:shift]} :
		xi + {{shift+1{yi[bitwidth-1]}},yi[bitwidth-2:shift]};
	  yo <= #1 z_is_pos ?   
		yi + {{shift+1{xi[bitwidth-1]}},xi[bitwidth-2:shift]} :
		yi - {{shift+1{xi[bitwidth-1]}},xi[bitwidth-2:shift]};
	  zo <= #1 z_is_pos ?   
		zi - constant :
		zi + constant;
       end
endmodule