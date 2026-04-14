module top_module(
  input clk,
  input reset,
  output reg [2:0] out
);always @(posedge clk) begin
    case(out)
      3'b000: out <= 3'b001;
      3'b001: out <= 3'b010;
      3'b010: out <= 3'b011;
      3'b011: out <= 3'b100;
      3'b100: out <= 3'b101;
      3'b101: out <= 3'b110;
      3'b110: out <= 3'b000;
      default: out <= 3'b000;
    endcase
    if(reset) begin
      out <= 3'b000;
    end
  end

endmodule