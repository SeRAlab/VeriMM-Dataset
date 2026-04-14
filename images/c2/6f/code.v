module data_mask(
  input [7:0] data_in,
  input [1:0] mask_in,
  output reg [7:0] data_out
);

  always @* begin
    case(mask_in)
      2'b00: data_out = data_in;
      2'b01: data_out = {4'b0000, data_in[7:4]};
      2'b10: data_out = {data_in[3:0], 4'b0000, data_in[7:4]};
      2'b11: data_out = data_in & 8'b11110000;
    endcase
  end

endmodule