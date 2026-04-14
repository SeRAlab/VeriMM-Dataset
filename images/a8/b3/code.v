module top_module(Q_reg,
    D,
    CLK,
    RST);output reg [3:0] Q_reg; // Changed from wire to reg
  input [3:0] D;
  input CLK;
  input RST;

  always @(posedge CLK) begin
    if (RST) begin
      Q_reg <= 4'b0000;
    end else begin
      Q_reg <= Q_reg + D;
    end
  end
endmodule