module top_module(output Q, Qn, input rst_l, input D, input clk);reg Q_reg, Qn_reg;

  always @ (posedge clk) begin
    if (!rst_l) begin
      Q_reg <= 0;
      Qn_reg <= 1;
    end
    else begin
      Q_reg <= D;
      Qn_reg <= ~D;
    end
  end

  assign Q = Q_reg;
  assign Qn = Qn_reg;

endmodule