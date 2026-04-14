module top_module(
  input [31:0] in,
  input [4:0] shift_amount,
  input [1:0] shift_type,
  output reg [31:0] out
);always @(*) begin
  case (shift_type)
    2'b00: out = in << shift_amount;
    2'b01: out = in >> shift_amount;
    2'b10: out = $signed(in) >>> shift_amount;
    default: out = in;
  endcase
end

endmodule