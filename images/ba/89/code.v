module top_module(
  input Reset_n_i,
  input Clk_i,
  input [15:0] D_i,
  input Enable_i,
  output reg [15:0] Q_o
);always @(posedge Clk_i, negedge Reset_n_i) begin
    if (~Reset_n_i) begin
      Q_o <= 16'h0000;
    end else if (Enable_i) begin
      Q_o <= D_i;
    end
  end

endmodule