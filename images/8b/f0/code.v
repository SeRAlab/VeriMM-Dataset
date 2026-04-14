module top_module(
  input clk,
  input reset,
  input enable,
  output reg [2:0] count
);always @(posedge clk) begin
    if (reset) begin
      count <= 3'b0;
    end else if (enable) begin
      case (count)
        3'b000: count <= 3'b001;
        3'b001: count <= 3'b010;
        3'b010: count <= 3'b011;
        3'b011: count <= 3'b100;
        3'b100: count <= 3'b101;
        3'b101: count <= 3'b110;
        3'b110: count <= 3'b000;
      endcase
    end
  end

endmodule