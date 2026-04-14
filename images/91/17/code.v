module top_module(CLK, D, EN, Q);input CLK, D, EN;
  output Q;

  reg Q_reg;

  always @(posedge CLK) begin
    if (EN) begin
      Q_reg <= D;
    end
  end

  assign Q = Q_reg;

endmodule