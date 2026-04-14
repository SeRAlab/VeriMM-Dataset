module top_module(
  input  [3:0] i_signal,
  output reg [1:0] o_signal // Change wire to reg
);always @(*) begin
    case(i_signal)
      4'b0000: o_signal = 2'b00;
      4'b0001: o_signal = 2'b01;
      4'b0010: o_signal = 2'b10;
      4'b0011: o_signal = 2'b11;
      4'b0100: o_signal = 2'b01;
      4'b0101: o_signal = 2'b10;
      4'b0110: o_signal = 2'b11;
      4'b0111: o_signal = 2'b00;
      4'b1000: o_signal = 2'b10;
      4'b1001: o_signal = 2'b11;
      4'b1010: o_signal = 2'b00;
      4'b1011: o_signal = 2'b01;
      4'b1100: o_signal = 2'b11;
      4'b1101: o_signal = 2'b00;
      4'b1110: o_signal = 2'b01;
      4'b1111: o_signal = 2'b10;
      default:  o_signal = 2'b00; //default value for undefined inputs
    endcase
  end

endmodule