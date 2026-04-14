module top_module(input c, input [NB-1:0] i, output [NB-1:0] o);parameter integer NB = 1;
   parameter integer DEL = 2;
   genvar 	     j;
   generate
      if(DEL > 1) begin
	for(j=0; j<NB; j=j+1) begin: dbit
	   reg [DEL-1:0] dreg = 0;
	   always @ (posedge c)
	     dreg <= {dreg[DEL-2:0], i[j]};
	   assign o[j] = dreg[DEL-1];
	end
      end
      else if(DEL == 1) begin
	 reg [NB-1:0] oq;
	 always @ (posedge c)
	   oq <= i;
	 assign o = oq;
      end
      else begin
	 assign o = i;
      end
   endgenerate
endmodule