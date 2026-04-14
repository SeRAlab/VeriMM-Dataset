module top_module(
  input [3:0] a,
  input [3:0] b,
  input [3:0] c,
  input [3:0] d,
  input [1:0] sel,
  input enable,
  output reg [3:0] out
);always @(*) begin
  if(enable == 1) begin
    case(sel)
      2'b00: out = a;
      2'b01: out = b;
      2'b10: out = c;
      2'b11: out = d;
    endcase
  end else begin
    out = 4'b0000;
  end
end

endmodule