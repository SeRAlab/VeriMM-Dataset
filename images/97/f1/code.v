module top_module(
  input [3:0] data_in,
  input [1:0] sel,
  output reg out
);always @(*)
begin
  case(sel)
    2'b00: out = sel[0] ? data_in[1] : data_in[0];
    2'b01: out = sel[0] ? data_in[3] : data_in[2];
    default: out = 1'b0;
  endcase
end

endmodule