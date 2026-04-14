module mux4to1_2bit_active_high (
  input [1:0] in0,
  input [1:0] in1,
  input [1:0] in2,
  input [1:0] in3,
  input [1:0] sel,
  input en,
  output reg [1:0] out
);

  always @(*) begin
    if (en) begin
      case (sel)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        2'b11: out = in3;
        default: out = 2'b00;
      endcase
    end else begin
      out = 2'b00;
    end
  end

endmodule