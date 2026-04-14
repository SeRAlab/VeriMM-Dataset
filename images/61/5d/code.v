module top_module(
  input clk,
  input rst_n,
  input [7:0] a,
  input [7:0] b,
  input [1:0] op,
  output [7:0] result,
  output valid
);reg [8:0] sum;
  assign result = sum[7:0];
  assign valid = (sum[8] == 1'b0);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      sum <= 9'b0;
    end
    else begin
      case (op)
        2'b00: sum <= a + b;
        2'b01: sum <= a - b;
        default: sum <= 9'b0;
      endcase
    end
  end

endmodule