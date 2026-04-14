module priority_encoder(
  input [3:0] one_hot_in,
  output reg [1:0] binary_out
);

  always @(*) begin
    casez(one_hot_in)
      4'b0001: binary_out = 2'b00;
      4'b0010: binary_out = 2'b01;
      4'b0100: binary_out = 2'b10;
      4'b1000: binary_out = 2'b11;
      default: binary_out = 2'b00;
    endcase
  end

endmodule