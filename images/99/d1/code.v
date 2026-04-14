module top_module(
  input clk,
  input reset,
  input enable,
  input [1:0] op,
  input [31:0] A,
  input [31:0] B,
  output reg [31:0] C
);always @(posedge clk) begin
    if (reset) begin
      C <= 0;
    end else if (enable) begin
      case (op)
        2'b00: C <= A + B;
        2'b01: C <= A - B;
        2'b10: C <= A * B;
        2'b11: C <= A / B;
        default: C <= 0;
      endcase
    end
  end

endmodule