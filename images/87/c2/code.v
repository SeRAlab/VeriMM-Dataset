module top_module(
  input clk,
  input reset,
  input [7:0] A,
  input [7:0] B,
  input [2:0] op,
  output reg [15:0] out
);always @(posedge clk) begin
    if(reset) begin
      out <= 16'h0000;
    end
    else begin
      case(op)
        3'b000: out <= A + B;
        3'b001: out <= A - B;
        3'b010: out <= A * B;
        3'b011: out <= A / B;
        default: out <= 16'h0000;
      endcase
    end
  end
endmodule