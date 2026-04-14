module top_module(q, reset, clock, data);input reset, clock, data;
   output q;
   reg 	  q;

   always @ (posedge clock)
     begin
	if(reset == 0)
	  q <= 0;
	else
	  q <= data;
     end
   
endmodule