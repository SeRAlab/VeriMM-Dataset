module top_module(
  input clk,
  input resetn,
  input [3:0] A,
  input [3:0] B,
  input ctrl,
  output reg [3:0] S,
  output reg [3:0] D
);always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      S <= 4'b0000;
      D <= 4'b0000;
    end
    else begin
      if (ctrl == 1'b0) begin
        S <= A + B;
        D <= 4'b0000;
      end
      else begin
        S <= 4'b0000;
        D <= A - B;
      end
    end
  end

endmodule