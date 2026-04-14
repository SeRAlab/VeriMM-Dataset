module top_module(CLK,CLR,D,PRE,Q);input  CLK;
  input  CLR;
  input  D;
  input  PRE;
  output  Q;
  reg  Q;
  always
    @(PRE or CLR)
      begin
      if(((CLR == 1'b0) && (PRE == 1'b1)))
        begin
        Q = 128'b0;
        end
      else      if(((PRE == 1'b0) && (CLR == 1'b1)))
        begin
        Q = ( ~ 128'b0);
        end
      else      if(((CLR !== 1'b1) || (PRE !== 1'b1)))
        begin
        Q = 128'bx;
        end
      end
  always
    @(posedge CLK)
      begin
      if(((PRE == 1'b1) && (CLR == 1'b1)))
        Q = D;
      end
endmodule