module top_module(
  input in0,
  input in1,
  input in2,
  input in3,
  input [1:0] sel,
  output reg [1:0] out
);always @(*) begin
  case(sel)
    2'b00: out = {in0, 1'b0};
    2'b01: out = {in1, 1'b0};
    2'b10: out = {in2, 1'b0};
    2'b11: out = {in3, 1'b0};
  endcase
end

endmodule