module top_module(state, grant, new_state);parameter size=4;
   
   input [size*size-1:0] state;
   input [size-1:0] grant;
   output [size*size-1:0] new_state;

   genvar i,j;
   
   generate
   for (i=0; i<size; i=i+1) begin:ol2
      for (j=0; j<size; j=j+1) begin:il2
         assign new_state[j*size+i]= (state[j*size+i]&&!grant[j])||(grant[i]);
      end
   end
   endgenerate

endmodule