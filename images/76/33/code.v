module top_module(
  input [3:0] k_map,
  input [1:0] row,
  input [1:0] col,
  output reg f_out
);always @(*) begin
    case ({row, col})
      2'b00: f_out = k_map[0]; // accessing bit 0
      2'b01: f_out = k_map[1]; // accessing bit 1
      2'b11: f_out = k_map[3]; // accessing bit 3
      2'b10: f_out = k_map[2]; // accessing bit 2
      default: f_out = 1'b0;
    endcase
  end

endmodule