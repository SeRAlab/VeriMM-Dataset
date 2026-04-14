module top_module(Q, Qc, S, R);input   S, R;
   output  Q, Qc;
   
   
   assign Q  = ~(S & Qc);
   assign Qc = ~(R & Q);

endmodule