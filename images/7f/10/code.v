module top_module(D,CLK,RSTB,Q,QN);input D;
 input CLK;
 input RSTB;
 output Q;
 output QN;

 reg Qtemp;

 always @(posedge CLK or negedge RSTB) begin
   if (~RSTB) begin
     Qtemp <= 1'b0;
   end else begin
     Qtemp <= D;
   end
 end

 assign QN = ~Qtemp;
 assign Q = Qtemp;

endmodule