module top_module(y, s, a0, a1);input s, a0, a1;
   output y;

   reg 	  y; 
   
   always @(s or a0 or a1)
     begin
	y = a0;
	if (s)
	  begin
	     y = a1;
	  end
     end

endmodule