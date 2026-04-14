module top_module(Q, Qc, D, En);input   D, En;
   output  Q, Qc;
   wire    S, R;
   
   assign S  = ~(D & En);
   assign R  = ~(~D & En);
   assign Q  = ~(S & Qc);
   assign Qc = ~(R & Q);

endmodule