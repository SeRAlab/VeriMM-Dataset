module bin_to_bcd(
  input [3:0] binary_in,
  output reg [7:0] bcd_out
);

  always @(*) begin
    bcd_out[7:4] = binary_in / 4'd10;
    bcd_out[3:0] = binary_in % 4'd10;
  end

endmodule