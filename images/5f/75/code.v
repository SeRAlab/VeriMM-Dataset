module top_module(
  input [3:0] in,
  output reg [2:0] out // Change wire to reg since we're assigning in an always block
);always @ (in) begin
    case (in)
      4'b0000, 4'b1000: out = 3'b000;
      4'b0001, 4'b1001: out = 3'b001;
      4'b0010, 4'b1010: out = 3'b010;
      4'b0011, 4'b1011: out = 3'b011;
      4'b0100, 4'b1100: out = 3'b100;
      4'b0101, 4'b1101: out = 3'b101;
      4'b0110, 4'b1110: out = 3'b110;
      4'b0111, 4'b1111: out = 3'b111;
      default: out = 3'bxxx; // optional default case to handle unused values
    endcase
  end

endmodule