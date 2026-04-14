module top_module(
  input clk,
  input rst,
  input [7:0] a,
  input [7:0] b,
  input [1:0] ctrl,
  output reg [7:0] result
);always @(posedge clk) begin
    if (rst) begin
      result <= 0;
    end else begin
      case (ctrl)
        2'b00: result <= a + b;
        2'b01: result <= a - b;
        2'b10: result <= a * b;
        2'b11: result <= a / b;
        default: result <= 0;
      endcase
    end
  end

endmodule