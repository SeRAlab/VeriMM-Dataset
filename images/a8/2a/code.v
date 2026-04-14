module top_module(G_in, B_out);parameter 	      WIDTH = 32;
   
   parameter 	      START = 0;
   
   parameter 	      STOP = WIDTH;

   
   input [WIDTH-1:0]  G_in;
   
   output [WIDTH-1:0] B_out;

   
   
   
   
   

   generate
      genvar 	      it;
      
      for (it=1;it<WIDTH;it=it+1) begin : XOR_LOOP
	 if (WIDTH-it-1 > STOP || WIDTH-it-1 < START) begin : CASE_ASSIGN
	    assign B_out[WIDTH-it-1] = G_in[WIDTH-it-1];
	 end else begin : CASE_XOR
	    assign B_out[WIDTH-it-1] = B_out[WIDTH-it]^G_in[WIDTH-it-1];
	 end
      end
   endgenerate
   
   
   
   
   
   
   
   assign 	   B_out[WIDTH-1] = G_in[WIDTH-1];endmodule