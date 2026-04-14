module top_module(D, G, Q, QN);input D, G;
  output Q, QN;
  reg [3:0] Q_reg;
  wire [3:0] QN_reg;

  always @(negedge G) begin
    if (G == 1'b0) begin
      Q_reg <= 4'b0000;
    end else begin
      Q_reg <= D;
    end
  end

  assign Q = Q_reg;
  assign QN = ~Q_reg;

endmodule