module mux16to1_1bit_active_high (
  input in0,
  input in1,
  input in2,
  input in3,
  input in4,
  input in5,
  input in6,
  input in7,
  input in8,
  input in9,
  input in10,
  input in11,
  input in12,
  input in13,
  input in14,
  input in15,
  input [3:0] sel,
  input en,
  output reg out
);

  always @(*) begin
    if (en) begin
      case (sel)
        4'b0000: out = in0;
        4'b0001: out = in1;
        4'b0010: out = in2;
        4'b0011: out = in3;
        4'b0100: out = in4;
        4'b0101: out = in5;
        4'b0110: out = in6;
        4'b0111: out = in7;
        4'b1000: out = in8;
        4'b1001: out = in9;
        4'b1010: out = in10;
        4'b1011: out = in11;
        4'b1100: out = in12;
        4'b1101: out = in13;
        4'b1110: out = in14;
        4'b1111: out = in15;
        default: out = 1'b0;
      endcase
    end else begin
      out = 1'b0;
    end
  end

endmodule