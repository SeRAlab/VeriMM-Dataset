module top_module(
  input [2:0] data_in,
  input enable,
  input [1:0] select,
  output reg [3:0] data_out
);always @ (enable, select, data_in)
begin
  if (enable)
  begin
    case (select)
      2'b00: data_out = {data_in[0], 1'b0, 1'b0, 1'b0};
      2'b01: data_out = {1'b0, data_in[1], 1'b0, 1'b0};
      2'b10: data_out = {1'b0, 1'b0, data_in[2], 1'b0};
      2'b11: data_out = {1'b0, 1'b0, 1'b0, 1'b0};
      default: data_out = {1'b0, 1'b0, 1'b0, 1'b0};
    endcase
  end
  else
    data_out = {1'b0, 1'b0, 1'b0, 1'b0};
end

endmodule