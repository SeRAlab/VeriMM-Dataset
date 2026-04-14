module mux8to1_8bit_active_low (
  input [7:0] in0,
  input [7:0] in1,
  input [7:0] in2,
  input [7:0] in3,
  input [7:0] in4,
  input [7:0] in5,
  input [7:0] in6,
  input [7:0] in7,
  input [2:0] sel,
  input en_n,
  output reg [7:0] out
);

  always @(*) begin
    if (~en_n) begin
      case (sel)
        3'b000: out = in0;
        3'b001: out = in1;
        3'b010: out = in2;
        3'b011: out = in3;
        3'b100: out = in4;
        3'b101: out = in5;
        3'b110: out = in6;
        3'b111: out = in7;
        default: out = 8'b00000000;
      endcase
    end else begin
      out = 8'b00000000;
    end
  end

endmodule