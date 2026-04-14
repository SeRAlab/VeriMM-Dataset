module top_module(D, Q, reset, clk);input [3:0] D;
  output [3:0] Q;
  input reset, clk;

  reg [3:0] Q_reg;

  always @(posedge clk, negedge reset) begin
    if (!reset) begin
      Q_reg <= 4'b0;
    end else begin
      Q_reg <= D;
    end
  end

  assign Q = Q_reg;

endmodule