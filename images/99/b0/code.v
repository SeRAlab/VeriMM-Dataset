module top_module(CLK, D, SET, RESET, DELAY, Q, QN);input CLK, D, SET, RESET, DELAY;
  output Q, QN;
  reg Q, QN;
  reg Q_next;
  wire NOT_CLK;
  
  assign NOT_CLK = ~CLK;
  
  always @(posedge CLK) begin
    if (SET) begin
      Q <= 1'b1;
      QN <= 1'b0;
    end else if (RESET) begin
      Q <= 1'b0;
      QN <= 1'b1;
    end else begin
      Q_next <= D;
    end
  end
  
  always @(negedge CLK) begin
    if (DELAY) begin
      Q <= Q_next;
      QN <= ~Q_next;
    end
  end
  
endmodule