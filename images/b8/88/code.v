module top_module(
  output reg [2:0] out,
  input clk,
  input ce,
  input clr,
  input [1:0] in
);always @(posedge clk) begin
    if (clr) begin
      out <= 3'b000;
    end else if (ce) begin
      case (in)
        2'b00: out <= 3'b001;
        2'b01: out <= 3'b010;
        2'b10: out <= 3'b011;
        2'b11: out <= 3'b100;
      endcase
    end
  end

endmodule