module divider(
  input [3:0] data_in,
  output reg [1:0] data_out
);

  always @(*) begin
    case (data_in)
      0: data_out = 2'b00;
      1: data_out = 2'b00;
      2: data_out = 2'b00;
      3: data_out = 2'b01;
      4: data_out = 2'b01;
      5: data_out = 2'b01;
      6: data_out = 2'b10;
      7: data_out = 2'b10;
      8: data_out = 2'b10;
      9: data_out = 2'b11;
      10: data_out = 2'b11;
      11: data_out = 2'b11;
      default: data_out = 2'b00; // handles unexpected inputs
    endcase
  end

endmodule