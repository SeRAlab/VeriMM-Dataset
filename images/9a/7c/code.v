module top_module(input wire Clock,input wire D,input Rst,output reg Q);always @(negedge Rst or  posedge Clock  )
	begin
	  if (!Rst)
      Q = 0;
	  else 
		Q = D;
	  end
endmodule