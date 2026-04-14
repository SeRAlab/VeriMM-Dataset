module top_module(
  input [3:0] in,
  input [1:0] sel,
  output reg [1:0] out
);always @*
  begin
    case({in, sel})
      4'b0000: out = 2'b00;
      4'b0001: out = 2'b01;
      4'b0100: out = 2'b11;
      4'b0101: out = 2'b10;
      4'b1000: out = 2'b10;
      4'b1001: out = 2'b11;
      4'b1100: out = 2'b01;
      4'b1101: out = 2'b00;
      default: out = 2'b00;
    endcase
  end

endmodule