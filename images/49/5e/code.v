module top_module(clk, rst, en, D, Q);input clk, rst, en;
  input [1:0] D;
  output [1:0] Q;

  reg [1:0] Q_next;

  always @(posedge clk) begin
    if (rst) begin
      Q_next <= 2'b0;
    end else if (en) begin
      Q_next <= D;
    end
  end

  assign Q = en ? Q_next : Q;

endmodule