module bit_masking(
  input [31:0] data_in,
  input [15:0] mask,
  input enable,
  output [15:0] data_out
);

  reg [15:0] temp_data_out;

  always @(*) begin
    if (enable) begin
      temp_data_out = data_in & mask;
    end else begin
      temp_data_out = 16'b0;
    end
  end

  assign data_out = temp_data_out;

endmodule