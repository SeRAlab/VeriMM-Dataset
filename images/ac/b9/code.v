module top_module(
  input [7:0] in0,
  input [7:0] in1,
  input [7:0] in2,
  input [7:0] in3,
  input sel,
  input en,
  output reg [7:0] out
);always @(*) begin
  case (sel)
    2'b00: out = in0;
    2'b01: out = in1;
    2'b10: out = in2;
    2'b11: out = in3;
    default: out = 8'h00;
  endcase
end

always @(posedge en) begin
  if (!en) out <= 8'h00;
end

endmodule