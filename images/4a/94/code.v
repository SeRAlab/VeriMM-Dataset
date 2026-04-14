module top_module(
  input in1,
  input in2,
  input in3,
  output reg [1:0] out
);always @(*) begin
    case({in1, in2, in3})
      3'b000: out = 2'b00;
      3'b001: out = 2'b01;
      3'b010: out = 2'b01;
      3'b011: out = 2'b10;
      3'b100: out = 2'b01;
      3'b101: out = 2'b10;
      3'b110: out = 2'b10;
      3'b111: out = 2'b11;
    endcase
  end

endmodule