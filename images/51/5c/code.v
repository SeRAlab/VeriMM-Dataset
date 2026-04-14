module top_module(
  input clk,
  input reset,
  input [7:0] in1,
  input [7:0] in2,
  input [3:0] sel,
  output reg [7:0] out
);always @(posedge clk, posedge reset) begin
    if (reset) begin
      out <= 8'b0;
    end else begin
      case (sel)
        4'b0000: out <= in1;
        4'b1111: out <= in2;
        default: out <= in1 & in2;
      endcase
    end
  end

endmodule