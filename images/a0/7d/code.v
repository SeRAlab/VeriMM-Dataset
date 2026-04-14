module mux2to1_8bit_active_low (
  input [7:0] in0,
  input [7:0] in1,
  input sel,
  input en_n,
  output reg [7:0] out
);

  always @(*) begin
    if (~en_n) begin
      case (sel)
        1'b0: out = in0;
        1'b1: out = in1;
        default: out = 8'b00000000;
      endcase
    end else begin
      out = 8'b00000000;
    end
  end

endmodule