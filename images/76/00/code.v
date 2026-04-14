module top_module(CLK, D, S, R, Q, QN);input CLK, D, S, R;
  output Q, QN;
  reg Q;

  always @(posedge CLK) begin
    if (S == 1'b1) begin
      Q <= 1'b1;
    end else if (R == 1'b1) begin
      Q <= 1'b0;
    end else begin
      Q <= D;
    end
  end

  assign QN = ~Q;

endmodule