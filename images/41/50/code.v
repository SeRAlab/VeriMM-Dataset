module top_module(
  input data_in_0,
  input data_in_1,
  input data_in_2,
  input data_in_3,
  input ctrl_sel_0,
  input ctrl_sel_1,
  output reg data_out
);always @(*) begin
  case ({ctrl_sel_1, ctrl_sel_0})
    2'b00: data_out = data_in_0;
    2'b01: data_out = data_in_1;
    2'b10: data_out = data_in_2;
    2'b11: data_out = data_in_3;
  endcase
end

endmodule