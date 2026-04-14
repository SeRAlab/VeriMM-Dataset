module top_module(indt,outdt0,outdt1);input indt;
	output outdt0;
	output outdt1;
	
	assign outdt1 = indt;
   assign outdt0 = ~indt;

endmodule