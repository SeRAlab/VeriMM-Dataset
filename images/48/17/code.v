module top_module(
  input [3:0] x,
  output reg [1:0] y
);always @* begin
    case(x)
      4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100:
        y = 2'b00;
      4'b0101, 4'b0110, 4'b0111, 4'b1000, 4'b1001:
        y = 2'b01;
      default:
        y = 2'b10;
    endcase
  end

endmodule