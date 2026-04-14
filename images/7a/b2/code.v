module top_module(
  input [1:0] sel,
  input [3:0] data,
  output reg out
);always @(*) begin
    case(sel)
      2'b00: out = data[0];
      2'b01: out = data[1];
      2'b10: out = data[2];
      2'b11: out = data[3];
    endcase
  end

endmodule