module top_module(
  input a,
  input b,
  input c,
  output reg [1:0] count
);always @(*) begin
    case ({a, b, c})
      3'b000: count = 2'b00;
      3'b001: count = 2'b01;
      3'b010: count = 2'b01;
      3'b011: count = 2'b10;
      3'b100: count = 2'b01;
      3'b101: count = 2'b10;
      3'b110: count = 2'b10;
      3'b111: count = 2'b11;
    endcase
  end

endmodule