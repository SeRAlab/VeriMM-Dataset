module top_module(
    input [3:0] in,
    output reg [1:0] out  // Change output to 'reg' type
);always @(*) begin
    case (in)
      4'b0000, 4'b0001, 4'b0010, 4'b0011:
        out = 2'b00;
      4'b0100, 4'b0101, 4'b0110, 4'b0111:
        out = 2'b01;
      4'b1000, 4'b1001, 4'b1010, 4'b1011:
        out = 2'b10;
      default:
        out = 2'b11;
    endcase
  end

endmodule