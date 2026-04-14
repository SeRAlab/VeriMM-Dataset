module top_module(
  input [2:0] in,
  output reg [1:0] out
);always @* begin
  case (in)
    3'b000, 3'b001: out = 2'b00;
    3'b010, 3'b011: out = 2'b01;
    3'b100, 3'b101: out = 2'b10;
    3'b110, 3'b111: out = 2'b11;
    default: out = 2'b00;
  endcase
end

endmodule