module top_module(input ci, i, co, output reg o=0);reg it = 0;
   always @ (posedge ci)
     it <= it ^ i;
   reg 	it_prev = 0;
   always @ (posedge co)
     begin
	it_prev <= it;
	o <= it ^ it_prev;
     end
endmodule