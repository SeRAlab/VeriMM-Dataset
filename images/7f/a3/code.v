module top_module(D, CLK, CLR, SET, Q, QN);input D, CLK, CLR, SET;
  output Q, QN;
  reg Q, QN;

  always @(posedge CLK or negedge CLR or posedge SET)
    if (~CLR)
      begin
        Q <= 1'b0;
        QN <= 1'b1;
      end
    else if (SET)
      begin
        Q <= 1'b1;
        QN <= 1'b0;
      end
    else
      begin
        Q <= D;
        QN <= ~D;
      end
endmodule