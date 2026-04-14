module top_module(
  input [31:0] in,
  input [1:0] shift,
  output reg [31:0] out
);always @(*)
  begin
    case(shift)
      2'b00: out = in;
      2'b01: out = {in[30:0], 1'b0};
      2'b10: out = {1'b0, in[31:1]};
      2'b11: out = {2'b00, in[31:2]};
    endcase
  end

endmodule